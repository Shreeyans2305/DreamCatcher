"""
Integration tests for Opportunities API:
Polymorphic CRUD (scholarships, courses, exams, internships),
rules management, and deterministic eligibility evaluation.
"""
import pytest
from fastapi.testclient import TestClient


def test_list_and_filter_opportunities(client: TestClient):
    # List all
    res = client.get("/api/v1/opportunities")
    assert res.status_code == 200
    data = res.json()
    assert "items" in data
    assert "total" in data
    assert data["total"] >= 10

    # Filter by type: scholarship
    res_sch = client.get("/api/v1/opportunities?type=scholarship")
    assert res_sch.status_code == 200
    assert all(o["type"] == "scholarship" for o in res_sch.json()["items"])

    # Filter by state: Maharashtra
    res_mh = client.get("/api/v1/opportunities?state=Maharashtra")
    assert res_mh.status_code == 200
    assert res_mh.json()["total"] >= 1


def test_create_scholarship_polymorphic(client: TestClient):
    payload = {
        "type": "scholarship",
        "title": "Gramin Kanya Utkarsha Scholarship 2026",
        "description": "Financial grant for rural female students pursuing graduation in STEM",
        "status": "active",
        "application_deadline": "2026-10-31",
        "scholarship": {
            "amount": 50000.0,
            "currency": "INR",
            "award_frequency": "annual",
            "renewable": True,
            "number_of_awards": 100,
            "application_process": "Apply via state portal with income certificate",
        },
        "rules": [
            {
                "rule_type": "GENDER",
                "operator": "EQ",
                "value": "female",
                "required": True,
                "description": "Must be female applicant",
            },
            {
                "rule_type": "INCOME",
                "operator": "LTE",
                "value": "250000",
                "required": True,
                "description": "Annual family income must not exceed 2.5 LPA",
            },
            {
                "rule_type": "PERCENTAGE",
                "operator": "GTE",
                "value": "60",
                "required": True,
                "description": "Minimum 60% in Class 12",
            },
        ],
    }
    res = client.post("/api/v1/opportunities", json=payload)
    assert res.status_code == 201
    opp = res.json()
    opp_id = opp["id"]
    assert opp["title"] == "Gramin Kanya Utkarsha Scholarship 2026"
    assert opp["scholarship"]["amount"] == 50000.0
    assert len(opp["eligibility_rules"]) == 3

    # Test eligibility evaluation with matching profile
    matching_profile = {
        "gender": "female",
        "income": 180000,
        "percentage": 74.5,
    }
    elig_res = client.post(f"/api/v1/opportunities/{opp_id}/check-eligibility", json=matching_profile)
    assert elig_res.status_code == 200
    elig_data = elig_res.json()
    assert elig_data["is_eligible"] is True
    assert elig_data["passed_rules_count"] == 3

    # Test eligibility evaluation with non-matching profile (income too high)
    failing_profile = {
        "gender": "female",
        "income": 500000,
        "percentage": 80.0,
    }
    fail_res = client.post(f"/api/v1/opportunities/{opp_id}/check-eligibility", json=failing_profile)
    assert fail_res.status_code == 200
    fail_data = fail_res.json()
    assert fail_data["is_eligible"] is False
    assert fail_data["passed_rules_count"] < 3

    # Add a new rule
    new_rule_payload = {
        "rule_type": "STATE",
        "operator": "EQ",
        "value": "Maharashtra",
        "required": True,
        "description": "Domicile of Maharashtra state",
    }
    rule_add_res = client.post(f"/api/v1/opportunities/{opp_id}/rules", json=new_rule_payload)
    assert rule_add_res.status_code == 201
    rule_id = rule_add_res.json()["id"]

    # Delete the rule
    rule_del_res = client.delete(f"/api/v1/opportunities/{opp_id}/rules/{rule_id}")
    assert rule_del_res.status_code == 200

    # Delete the opportunity
    del_res = client.delete(f"/api/v1/opportunities/{opp_id}")
    assert del_res.status_code == 200


def test_create_internship_and_course(client: TestClient):
    # Create internship
    internship_payload = {
        "type": "internship",
        "title": "Rural Community Health Summer Fellowship",
        "description": "Field research and health data collection across primary health centers",
        "status": "active",
        "internship": {
            "remote": False,
            "duration": "8 weeks",
            "stipend": 12000.0,
            "work_description": "Data collection at rural clinics",
        },
    }
    int_res = client.post("/api/v1/opportunities", json=internship_payload)
    assert int_res.status_code == 201
    assert int_res.json()["internship"]["stipend"] == 12000.0

    # Create course
    course_payload = {
        "type": "course",
        "title": "Diploma in Precision Agriculture & Drone Operations",
        "description": "Vocational course covering drone maintenance and farm multispectral imaging",
        "status": "active",
        "course": {
            "education_level": "diploma",
            "field": "Agricultural Technology",
            "duration": "1 year",
            "mode": "full_time",
        },
    }
    course_res = client.post("/api/v1/opportunities", json=course_payload)
    assert course_res.status_code == 201
    assert course_res.json()["course"]["education_level"] == "diploma"
