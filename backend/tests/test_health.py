"""
Health endpoint tests.
"""


def test_root(client):
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["project"] == "DreamCatcher"
    assert data["phase"] == 1


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"
    assert data["service"] == "dreamcatcher-backend"


def test_health_db(client):
    """
    Checks DB connectivity — requires PostgreSQL to be running.
    Will return 503 if DB is not available (which is acceptable in CI without DB).
    """
    response = client.get("/health/db")
    if response.status_code == 200:
        data = response.json()
        assert data["status"] == "ok"
        assert data["database"] == "connected"
        assert "postgresql_version" in data
        assert "pgvector_installed" in data
    else:
        # In environments without a running DB, 503 is expected
        assert response.status_code == 503
