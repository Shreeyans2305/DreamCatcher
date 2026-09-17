"""
Integration tests for Reference Catalogues API:
Languages, Locations, Skills, Interests, Institutions, Organizations.
"""
import pytest
from fastapi.testclient import TestClient


def test_list_languages(client: TestClient):
    response = client.get("/api/v1/languages")
    assert response.status_code == 200
    languages = response.json()
    assert isinstance(languages, list)
    assert len(languages) >= 9  # seeded languages
    codes = [l["code"] for l in languages]
    assert "en" in codes
    assert "hi" in codes
    assert "mr" in codes


def test_get_language_by_code(client: TestClient):
    response = client.get("/api/v1/languages/hi")
    assert response.status_code == 200
    data = response.json()
    assert data["code"] == "hi"
    assert data["name"] == "Hindi"

    # Non-existent language
    res_404 = client.get("/api/v1/languages/xyz_nonexistent")
    assert res_404.status_code == 404


def test_list_locations(client: TestClient):
    response = client.get("/api/v1/locations")
    assert response.status_code == 200
    data = response.json()
    assert "items" in data
    assert "total" in data
    assert data["total"] >= 9

    # Filter by state
    res_mh = client.get("/api/v1/locations?state=Maharashtra")
    assert res_mh.status_code == 200
    mh_data = res_mh.json()
    assert all("Maharashtra" in (item["state"] or "") for item in mh_data["items"])


def test_create_and_get_location(client: TestClient):
    payload = {
        "country": "India",
        "state": "Gujarat",
        "district": "Kutch",
        "taluka": "Bhuj",
        "village": "Madhapar",
        "pincode": "370020",
        "rural_urban": "rural",
    }
    create_res = client.post("/api/v1/locations", json=payload)
    assert create_res.status_code == 201
    loc = create_res.json()
    assert loc["state"] == "Gujarat"
    assert loc["village"] == "Madhapar"

    # Get by ID
    get_res = client.get(f"/api/v1/locations/{loc['id']}")
    assert get_res.status_code == 200
    assert get_res.json()["district"] == "Kutch"

    # Find or create location (idempotent lookup)
    foc_res = client.post("/api/v1/locations/find-or-create", json={
        "country": "India",
        "state": "Gujarat",
        "district": "Kutch",
        "taluka": "Bhuj",
        "village": "Madhapar",
        "pincode": "370020",
        "rural_urban": "rural",
    })
    assert foc_res.status_code == 200
    assert foc_res.json()["id"] == loc["id"]

    # Find or create for a new state/district
    foc_new = client.post("/api/v1/locations/find-or-create", json={
        "country": "India",
        "state": "Tamil Nadu",
        "district": "Coimbatore",
        "rural_urban": "urban",
    })
    assert foc_new.status_code == 200
    assert foc_new.json()["state"] == "Tamil Nadu"
    assert foc_new.json()["district"] == "Coimbatore"


def test_skills_crud(client: TestClient):
    import uuid
    # List
    list_res = client.get("/api/v1/skills")
    assert list_res.status_code == 200
    assert list_res.json()["total"] >= 10

    # Create new skill
    skill_name = f"Solar Pump Repair {uuid.uuid4().hex[:6]}"
    skill_payload = {
        "canonical_name": skill_name,
        "category": "vocational",
        "description": "Maintenance and troubleshooting of agricultural solar water pumps",
    }
    create_res = client.post("/api/v1/skills", json=skill_payload)
    assert create_res.status_code == 201
    created_skill = create_res.json()
    assert created_skill["canonical_name"] == skill_name

    # Get by ID
    get_res = client.get(f"/api/v1/skills/{created_skill['id']}")
    assert get_res.status_code == 200
    assert get_res.json()["category"] == "vocational"


def test_interests_crud(client: TestClient):
    import uuid
    list_res = client.get("/api/v1/interests")
    assert list_res.status_code == 200
    assert list_res.json()["total"] >= 9

    interest_name = f"Dairy Farming {uuid.uuid4().hex[:6]}"
    interest_payload = {
        "name": interest_name,
        "category": "agriculture",
        "description": "Interest in modern dairy management and breeding",
    }
    create_res = client.post("/api/v1/interests", json=interest_payload)
    assert create_res.status_code == 201
    created_interest = create_res.json()

    get_res = client.get(f"/api/v1/interests/{created_interest['id']}")
    assert get_res.status_code == 200
    assert get_res.json()["name"] == interest_name


def test_institutions_and_organizations(client: TestClient):
    import uuid
    # List organizations
    orgs_res = client.get("/api/v1/organizations")
    assert orgs_res.status_code == 200
    assert orgs_res.json()["total"] >= 5

    # Create organization
    org_name = f"Rural Development Trust {uuid.uuid4().hex[:6]}"
    org_payload = {
        "name": org_name,
        "type": "ngo",
        "description": "NGO working for grassroots rural upliftment",
        "website": "https://rdt-india.org",
    }
    org_create = client.post("/api/v1/organizations", json=org_payload)
    assert org_create.status_code == 201
    org_id = org_create.json()["id"]

    # List institutions
    inst_res = client.get("/api/v1/institutions")
    assert inst_res.status_code == 200
    assert inst_res.json()["total"] >= 5

    # Create institution
    inst_name = f"District Institute of Rural Technology {uuid.uuid4().hex[:6]}"
    inst_payload = {
        "name": inst_name,
        "institution_type": "polytechnic",
        "organization_id": org_id,
        "government_private": "government",
        "description": "Polytechnic offering vocational and engineering diplomas",
    }
    inst_create = client.post("/api/v1/institutions", json=inst_payload)
    assert inst_create.status_code == 201
    assert inst_create.json()["name"] == inst_name
