"""
Integration tests for Careers API:
CRUD, pathways, requirements, and skill-based matching for students.
"""
import pytest
from fastapi.testclient import TestClient


def test_careers_lifecycle_and_matching(client: TestClient):
    # 1. List seeded careers
    list_res = client.get("/api/v1/careers")
    assert list_res.status_code == 200
    data = list_res.json()
    assert "items" in data
    assert "total" in data
    assert data["total"] >= 5

    # 2. Create a new career
    import uuid
    career_name = f"Rural Solar Specialist {uuid.uuid4().hex[:6]}"
    career_payload = {
        "name": career_name,
        "description": "Designs, installs, and manages off-grid solar power systems for rural communities",
        "industry": "Renewable Energy",
        "career_level": "entry",
        "demand_level": "very_high",
    }
    create_res = client.post("/api/v1/careers", json=career_payload)
    assert create_res.status_code == 201
    career = create_res.json()
    career_id = career["id"]
    assert career["name"] == career_name

    # 3. Add a pathway to the career
    pathway_payload = {
        "pathway_name": "Vocational ITI Route to Microgrid Tech",
        "description": "Complete Class 10 -> ITI Electrician -> 6-month Solar Cert -> Microgrid Tech",
        "steps": [
            {"step": 1, "level": "secondary", "description": "Complete Class 10 with Science"},
            {"step": 2, "level": "vocational", "description": "2-year ITI Electrician trade certificate"},
            {"step": 3, "level": "certificate", "description": "Suryamitra solar PV installer certificate"},
        ],
        "is_alternative": True,
    }
    pathway_res = client.post(f"/api/v1/careers/{career_id}/pathways", json=pathway_payload)
    assert pathway_res.status_code == 201
    pathway_data = pathway_res.json()
    assert pathway_data["pathway_name"] == "Vocational ITI Route to Microgrid Tech"

    # 4. Get career detail with pathways
    detail_res = client.get(f"/api/v1/careers/{career_id}")
    assert detail_res.status_code == 200
    detail = detail_res.json()
    assert len(detail["pathways"]) == 1
    assert detail["industry"] == "Renewable Energy"

    # 5. Update career
    update_payload = {
        "demand_level": "very_high",
        "description": "Updated description for solar technician career",
    }
    update_res = client.put(f"/api/v1/careers/{career_id}", json=update_payload)
    assert update_res.status_code == 200
    assert "Updated description" in update_res.json()["description"]

    # 6. Test skill-based career matching for student
    # Get any student from list
    students_res = client.get("/api/v1/students")
    students = students_res.json()["items"]
    if students:
        student_id = students[0]["id"]
        match_res = client.get(f"/api/v1/careers/match/student/{student_id}")
        assert match_res.status_code == 200
        matched_careers = match_res.json()
        assert isinstance(matched_careers, list)

    # 7. Delete career
    del_res = client.delete(f"/api/v1/careers/{career_id}")
    assert del_res.status_code == 200

    assert client.get(f"/api/v1/careers/{career_id}").status_code == 404
