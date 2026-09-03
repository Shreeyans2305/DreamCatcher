"""
Generate Vertex AI embeddings for all opportunity documents.

Usage:
    cd backend
    source .venv/bin/activate
    python scripts/generate_embeddings.py

Prerequisites:
    - gcloud auth application-default login
    - Documents seeded via: python scripts/seed_documents.py
"""
import sys
import os
import logging

# Add backend directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)


def main():
    """Generate Vertex AI embeddings for all un-embedded documents."""
    from app.core.config import settings
    from app.core.database import SessionLocal
    from app.services.embedding_service import EmbeddingService

    print("🧠 DreamCatcher — Vertex AI Embedding Generator")
    print(f"   Project:  {settings.gcp_project_id}")
    print(f"   Location: {settings.gcp_location}")
    print(f"   Model:    {settings.embedding_model}")
    print(f"   Dim:      {settings.vector_dim}")
    print()

    db = SessionLocal()
    try:
        results = EmbeddingService.embed_all_documents(db)

        print(f"\n✅ Embedding generation complete!")
        print(f"   Documents processed:   {results['documents_processed']}")
        print(f"   Total chunks created:  {results['total_chunks_created']}")

        if results["errors"]:
            print(f"\n⚠️  Errors ({len(results['errors'])}):")
            for err in results["errors"]:
                print(f"   - {err}")
        else:
            print("   No errors encountered.")

    except Exception as e:
        print(f"\n❌ Fatal error: {e}")
        logger.exception("Embedding generation failed")
        sys.exit(1)
    finally:
        db.close()


if __name__ == "__main__":
    main()
