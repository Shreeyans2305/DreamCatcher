"""
Integration tests for Students API:
CRUD, education, skills, interests, aspirations, and automated eligibility discovery.
"""
import pytest
from fastapi.testclient import TestClient


def test_student_full_lifecycle(client: TestClient):
    # 1. Register a student
    student_payload = {
        "name": "Kavita Ramesh Patil",
        "phone": "+919811223344",
        "email": "kavita.patil@example.com",
        "gender": "female",
        "date_of_birth": "2006-05-15",
        "preferred_language": "mr",
    }
    create_res = client.post("/api/v1/students", json=student_payload)
    assert create_res.status_code == 201
    student = create_res.json()
    student_id = student["id"]
    assert student["name"] == "Kavita Ramesh Patil"
    assert student["preferred_language"] == "mr"
    assert student["profile_completeness"] > 0.0

    # 2. List students with search
    list_res = client.get("/api/v1/students?search=Kavita")
    assert list_res.status_code == 200
    list_data = list_res.json()
    assert list_data["total"] >= 1
    assert any(s["id"] == student_id for s in list_data["items"])

    # 3. Update student profile
    update_payload = {
        "phone": "+919811223399",
    }
    update_res = client.put(f"/api/v1/students/{student_id}", json=update_payload)
    assert update_res.status_code == 200
    assert update_res.json()["phone"] == "+919811223399"

    # 4. Add education record with subject marks
    edu_payload = {
        "institution_name": "Zilla Parishad High School, Dindori",
        "education_level": "secondary",
        "board": "Maharashtra State Board",
        "field_of_study": "General",
        "status": "completed",
        "subjects": [
            {
                "subject": "Mathematics",
                "marks": 88.0,
                "maximum_marks": 100.0,
                "percentage": 88.0,
            },
            {
                "subject": "Science",
                "marks": 82.0,
                "maximum_marks": 100.0,
                "percentage": 82.0,
            },
        ],
    }
    edu_res = client.post(f"/api/v1/students/{student_id}/education", json=edu_payload)
    assert edu_res.status_code == 201
    edu = edu_res.json()
    assert edu["education_level"] == "secondary"
    assert len(edu["subjects"]) == 2
    edu_id = edu["id"]

    # 5. Link skill
    # Fetch an existing skill
    skills_res = client.get("/api/v1/skills")
    first_skill_id = skills_res.json()["items"][0]["id"]

    skill_payload = {
        "skill_id": first_skill_id,
        "proficiency": "intermediate",
        "years_experience": 1.5,
    }
    skill_link_res = client.post(f"/api/v1/students/{student_id}/skills", json=skill_payload)
    assert skill_link_res.status_code == 201
    assert skill_link_res.json()["proficiency"] == "intermediate"

    # 6. Link interest
    interests_res = client.get("/api/v1/interests")
    first_interest_id = interests_res.json()["items"][0]["id"]

    interest_payload = {
        "interest_id": first_interest_id,
        "strength": 0.9,
    }
    interest_link_res = client.post(f"/api/v1/students/{student_id}/interests", json=interest_payload)
    assert interest_link_res.status_code == 201
    assert interest_link_res.json()["strength"] == 0.9

    # 7. Add aspiration
    asp_payload = {
        "aspiration_text": "I want to become a software engineer and work on rural agritech apps.",
        "priority": 1,
    }
    asp_res = client.post(f"/api/v1/students/{student_id}/aspirations", json=asp_payload)
    assert asp_res.status_code == 201
    assert "software engineer" in asp_res.json()["aspiration_text"]

    # 8. Retrieve complete student detail
    detail_res = client.get(f"/api/v1/students/{student_id}")
    assert detail_res.status_code == 200
    detail = detail_res.json()
    assert len(detail["education_records"]) == 1
    assert len(detail["skills"]) == 1
    assert len(detail["interests"]) == 1
    assert len(detail["aspirations"]) == 1
    assert detail["profile_completeness"] > 0.5  # Completeness increased with enriched data!

    # 9. Test student eligibility check endpoint
    elig_res = client.get(f"/api/v1/students/{student_id}/eligible-opportunities")
    assert elig_res.status_code == 200
    assert isinstance(elig_res.json(), list)

    # 10. Delete sub-resources
    del_edu_res = client.delete(f"/api/v1/students/{student_id}/education/{edu_id}")
    assert del_edu_res.status_code == 200

    del_skill_res = client.delete(f"/api/v1/students/{student_id}/skills/{first_skill_id}")
    assert del_skill_res.status_code == 200

    del_interest_res = client.delete(f"/api/v1/students/{student_id}/interests/{first_interest_id}")
    assert del_interest_res.status_code == 200

    # 11. Delete student
    del_res = client.delete(f"/api/v1/students/{student_id}")
    assert del_res.status_code == 200

    # Verify 404 on deleted student
    assert client.get(f"/api/v1/students/{student_id}").status_code == 404
