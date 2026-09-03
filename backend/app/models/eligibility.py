"""
Eligibility Engine — structured rules for opportunity eligibility.

Design philosophy:
  - The LLM must NOT determine eligibility.
  - All eligibility criteria are stored as structured rules.
  - The application evaluates rules deterministically.

Compound conditions (AND/OR groups):
  - rule_group_id: groups rules that belong to the same compound condition.
  - group_operator: AND | OR — how rules in the same group combine.
  - Rules without a group_id are treated as independent AND conditions.

Example compound rule:
  Rule 1: rule_group_id=G1, rule_type=INCOME,    operator=LT,  value=250000
  Rule 2: rule_group_id=G1, rule_type=STATE,     operator=EQ,  value=Maharashtra
  → group G1 requires BOTH conditions (AND)

  Rule 3: rule_group_id=G2, rule_type=GENDER,    operator=EQ,  value=female
  → group G2 is independent

  Final: G1 AND G2 = INCOME < 250000 AND STATE = Maharashtra AND GENDER = female
"""
import uuid
import enum
from datetime import datetime

from sqlalchemy import Boolean, DateTime, Enum, ForeignKey, Integer, String, Text, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, UUIDPrimaryKeyMixin


class RuleType(str, enum.Enum):
    AGE = "AGE"
    INCOME = "INCOME"
    GENDER = "GENDER"
    SOCIAL_CATEGORY = "SOCIAL_CATEGORY"         # SC / ST / OBC / General
    STATE = "STATE"
    DISTRICT = "DISTRICT"
    EDUCATION_LEVEL = "EDUCATION_LEVEL"
    BOARD = "BOARD"
    PERCENTAGE = "PERCENTAGE"
    SUBJECT = "SUBJECT"
    SKILL = "SKILL"
    RURAL_STATUS = "RURAL_STATUS"
    INSTITUTION_TYPE = "INSTITUTION_TYPE"
    NATIONALITY = "NATIONALITY"
    DISABILITY = "DISABILITY"
    OTHER = "OTHER"


class RuleOperator(str, enum.Enum):
    EQ = "EQ"           # equals
    NEQ = "NEQ"         # not equals
    LT = "LT"           # less than
    LTE = "LTE"         # less than or equal
    GT = "GT"           # greater than
    GTE = "GTE"         # greater than or equal
    IN = "IN"           # value in list (value field should be comma-separated)
    NOT_IN = "NOT_IN"   # value not in list
    EXISTS = "EXISTS"   # field exists / is set


class GroupOperator(str, enum.Enum):
    AND = "AND"
    OR = "OR"


class EligibilityRule(UUIDPrimaryKeyMixin, Base):
    """
    A single eligibility criterion for an opportunity.

    To express compound conditions, assign the same rule_group_id to multiple
    rules and set group_operator to AND or OR.
    Rules without rule_group_id are evaluated as independent AND conditions.
    """

    __tablename__ = "eligibility_rules"

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    opportunity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunities.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    rule_type: Mapped[RuleType] = mapped_column(
        Enum(RuleType, name="rule_type_enum", values_callable=enum_values),
        nullable=False,
        index=True,
    )
    operator: Mapped[RuleOperator] = mapped_column(
        Enum(RuleOperator, name="rule_operator_enum", values_callable=enum_values),
        nullable=False,
    )
    value: Mapped[str] = mapped_column(
        String(500),
        nullable=False,
        comment="Rule value, e.g. '250000', 'Maharashtra', 'SC,ST,OBC'",
    )
    unit: Mapped[str | None] = mapped_column(
        String(50),
        nullable=True,
        comment="Optional unit, e.g. 'years' for AGE, 'INR' for INCOME",
    )
    required: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        default=True,
        comment="If False, this is a preferred (non-disqualifying) criterion",
    )
    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
        comment="Human-readable description of the rule for display/debug",
    )

    # Compound condition support
    rule_group_id: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
        comment="Group identifier for compound AND/OR conditions",
    )
    group_operator: Mapped[GroupOperator] = mapped_column(
        Enum(GroupOperator, name="group_operator_enum", values_callable=enum_values),
        nullable=False,
        default=GroupOperator.AND,
        comment="How rules in the same rule_group_id are combined",
    )
    sort_order: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=0,
        comment="Display order within a group",
    )

    # Relationship
    opportunity: Mapped["Opportunity"] = relationship(back_populates="eligibility_rules")  # noqa: F821

    def __repr__(self) -> str:
        return f"<EligibilityRule {self.rule_type} {self.operator} {self.value}>"
