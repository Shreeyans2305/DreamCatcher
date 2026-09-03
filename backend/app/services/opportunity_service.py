"""
Service layer for Opportunity domain: CRUD, polymorphic subtype management,
and deterministic eligibility evaluation.
"""
from typing import Optional, List, Tuple, Dict, Any
from uuid import UUID
from datetime import date
from sqlalchemy.orm import Session, joinedload, selectinload
from sqlalchemy import select, func, or_, and_

from app.models.opportunity import Opportunity, OpportunityType, OpportunityStatus, VerificationStatus
from app.models.scholarship import Scholarship
from app.models.course import Course, CourseInstitution
from app.models.exam import EntranceExam
from app.models.internship import Internship
from app.models.eligibility import EligibilityRule, RuleOperator, RuleType, GroupOperator
from app.models.location import Location
from app.schemas.opportunity import (
    OpportunityCreate, OpportunityUpdate,
    EligibilityRuleCreate, RuleEvaluationItem, EligibilityCheckResult,
)


class OpportunityService:
    @staticmethod
    def create_opportunity(db: Session, data: OpportunityCreate) -> Opportunity:
        scholarship_data = data.scholarship
        course_data = data.course
        exam_data = data.entrance_exam
        internship_data = data.internship
        rules_data = data.rules

        # Core Opportunity fields
        core_data = data.model_dump(
            exclude={"scholarship", "course", "entrance_exam", "internship", "rules"}
        )
        opp = Opportunity(**core_data)
        db.add(opp)
        db.flush()

        # Create specialized child record
        if data.type == OpportunityType.SCHOLARSHIP and scholarship_data:
            scholarship = Scholarship(opportunity_id=opp.id, **scholarship_data.model_dump())
            db.add(scholarship)
        elif data.type == OpportunityType.COURSE and course_data:
            course = Course(opportunity_id=opp.id, **course_data.model_dump())
            db.add(course)
        elif data.type == OpportunityType.ENTRANCE_EXAM and exam_data:
            exam = EntranceExam(opportunity_id=opp.id, **exam_data.model_dump())
            db.add(exam)
        elif data.type == OpportunityType.INTERNSHIP and internship_data:
            internship = Internship(opportunity_id=opp.id, **internship_data.model_dump())
            db.add(internship)

        # Create eligibility rules if provided
        if rules_data:
            for rule_in in rules_data:
                rule = EligibilityRule(opportunity_id=opp.id, **rule_in.model_dump())
                db.add(rule)

        db.commit()
        return OpportunityService.get_opportunity_detail(db, opp.id)  # type: ignore

    @staticmethod
    def get_opportunity(db: Session, opportunity_id: UUID) -> Optional[Opportunity]:
        return db.execute(
            select(Opportunity).where(Opportunity.id == opportunity_id)
        ).scalar_one_or_none()

    @staticmethod
    def get_opportunity_detail(db: Session, opportunity_id: UUID) -> Optional[Opportunity]:
        stmt = (
            select(Opportunity)
            .options(
                joinedload(Opportunity.location),
                joinedload(Opportunity.organization),
                joinedload(Opportunity.scholarship),
                joinedload(Opportunity.course).selectinload(Course.course_institutions).joinedload(CourseInstitution.institution),
                joinedload(Opportunity.entrance_exam),
                joinedload(Opportunity.internship),
                selectinload(Opportunity.eligibility_rules),
            )
            .where(Opportunity.id == opportunity_id)
        )
        return db.execute(stmt).scalar_one_or_none()

    @staticmethod
    def list_opportunities(
        db: Session,
        opp_type: Optional[OpportunityType] = None,
        status: Optional[OpportunityStatus] = None,
        state: Optional[str] = None,
        location_id: Optional[UUID] = None,
        search: Optional[str] = None,
        limit: int = 20,
        offset: int = 0,
    ) -> Tuple[List[Opportunity], int]:
        stmt = select(Opportunity)
        count_stmt = select(func.count(Opportunity.id))

        if opp_type:
            stmt = stmt.where(Opportunity.type == opp_type)
            count_stmt = count_stmt.where(Opportunity.type == opp_type)

        if status:
            stmt = stmt.where(Opportunity.status == status)
            count_stmt = count_stmt.where(Opportunity.status == status)

        if location_id:
            stmt = stmt.where(Opportunity.location_id == location_id)
            count_stmt = count_stmt.where(Opportunity.location_id == location_id)

        if state:
            stmt = stmt.outerjoin(Location, Opportunity.location_id == Location.id).where(
                or_(
                    Location.state.ilike(f"%{state}%"),
                    Opportunity.location_id.is_(None),  # National / all-India
                )
            )
            count_stmt = count_stmt.outerjoin(Location, Opportunity.location_id == Location.id).where(
                or_(
                    Location.state.ilike(f"%{state}%"),
                    Opportunity.location_id.is_(None),
                )
            )

        if search:
            stmt = stmt.where(
                or_(
                    Opportunity.title.ilike(f"%{search}%"),
                    Opportunity.description.ilike(f"%{search}%"),
                )
            )
            count_stmt = count_stmt.where(
                or_(
                    Opportunity.title.ilike(f"%{search}%"),
                    Opportunity.description.ilike(f"%{search}%"),
                )
            )

        total = db.execute(count_stmt).scalar_one()
        items = list(
            db.execute(
                stmt.order_by(Opportunity.created_at.desc())
                .offset(offset)
                .limit(limit)
            ).scalars().all()
        )
        return items, total

    @staticmethod
    def update_opportunity(db: Session, opportunity_id: UUID, data: OpportunityUpdate) -> Optional[Opportunity]:
        opp = OpportunityService.get_opportunity(db, opportunity_id)
        if not opp:
            return None

        update_dict = data.model_dump(
            exclude_unset=True,
            exclude={"scholarship", "course", "entrance_exam", "internship"},
        )
        for key, value in update_dict.items():
            setattr(opp, key, value)

        # Subtype updates
        if data.scholarship and opp.scholarship:
            for k, v in data.scholarship.model_dump(exclude_unset=True).items():
                setattr(opp.scholarship, k, v)
        if data.course and opp.course:
            for k, v in data.course.model_dump(exclude_unset=True).items():
                setattr(opp.course, k, v)
        if data.entrance_exam and opp.entrance_exam:
            for k, v in data.entrance_exam.model_dump(exclude_unset=True).items():
                setattr(opp.entrance_exam, k, v)
        if data.internship and opp.internship:
            for k, v in data.internship.model_dump(exclude_unset=True).items():
                setattr(opp.internship, k, v)

        db.commit()
        return OpportunityService.get_opportunity_detail(db, opportunity_id)

    @staticmethod
    def delete_opportunity(db: Session, opportunity_id: UUID) -> bool:
        opp = OpportunityService.get_opportunity(db, opportunity_id)
        if not opp:
            return False
        db.delete(opp)
        db.commit()
        return True

    @staticmethod
    def add_rule(db: Session, opportunity_id: UUID, data: EligibilityRuleCreate) -> Optional[EligibilityRule]:
        opp = OpportunityService.get_opportunity(db, opportunity_id)
        if not opp:
            return None
        rule = EligibilityRule(opportunity_id=opportunity_id, **data.model_dump())
        db.add(rule)
        db.commit()
        db.refresh(rule)
        return rule

    @staticmethod
    def delete_rule(db: Session, opportunity_id: UUID, rule_id: UUID) -> bool:
        rule = db.execute(
            select(EligibilityRule).where(
                EligibilityRule.id == rule_id,
                EligibilityRule.opportunity_id == opportunity_id,
            )
        ).scalar_one_or_none()
        if not rule:
            return False
        db.delete(rule)
        db.commit()
        return True

    @staticmethod
    def evaluate_eligibility(
        db: Session,
        opportunity_id: UUID,
        profile: Dict[str, Any],
    ) -> Optional[EligibilityCheckResult]:
        opp = OpportunityService.get_opportunity(db, opportunity_id)
        if not opp:
            return None

        rules = list(
            db.execute(
                select(EligibilityRule).where(EligibilityRule.opportunity_id == opportunity_id)
            ).scalars().all()
        )

        evaluations: List[RuleEvaluationItem] = []
        for rule in rules:
            field = rule.rule_type.value.lower()
            student_val = profile.get(field)
            rule_val = rule.value

            passed = False
            desc = rule.description or f"{field} {rule.operator.value} {rule_val}"

            if student_val is None:
                passed = not rule.required
            elif rule.operator == RuleOperator.EQ:
                passed = str(student_val).strip().lower() == rule_val.strip().lower()
            elif rule.operator == RuleOperator.NEQ:
                passed = str(student_val).strip().lower() != rule_val.strip().lower()
            elif rule.operator == RuleOperator.LTE:
                try:
                    passed = float(student_val) <= float(rule_val)
                except (ValueError, TypeError):
                    passed = False
            elif rule.operator == RuleOperator.LT:
                try:
                    passed = float(student_val) < float(rule_val)
                except (ValueError, TypeError):
                    passed = False
            elif rule.operator == RuleOperator.GTE:
                try:
                    passed = float(student_val) >= float(rule_val)
                except (ValueError, TypeError):
                    passed = False
            elif rule.operator == RuleOperator.GT:
                try:
                    passed = float(student_val) > float(rule_val)
                except (ValueError, TypeError):
                    passed = False
            elif rule.operator == RuleOperator.IN:
                allowed = [v.strip().lower() for v in rule_val.split(",")]
                passed = str(student_val).strip().lower() in allowed
            elif rule.operator == RuleOperator.NOT_IN:
                excluded = [v.strip().lower() for v in rule_val.split(",")]
                passed = str(student_val).strip().lower() not in excluded
            elif rule.operator == RuleOperator.EXISTS:
                passed = student_val is not None

            evaluations.append(
                RuleEvaluationItem(
                    rule=f"{rule.rule_type.value} {rule.operator.value} {rule.value}",
                    rule_type=rule.rule_type,
                    operator=rule.operator,
                    expected_value=rule.value,
                    student_value=student_val,
                    required=rule.required,
                    passed=passed,
                    description=desc,
                )
            )

        is_eligible = all(r.passed for r in evaluations if r.required)
        passed_count = sum(1 for r in evaluations if r.passed)

        return EligibilityCheckResult(
            opportunity_id=opp.id,
            opportunity_title=opp.title,
            is_eligible=is_eligible,
            passed_rules_count=passed_count,
            total_rules_count=len(evaluations),
            rule_evaluations=evaluations,
        )
