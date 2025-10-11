from fastapi import APIRouter

router = APIRouter()


@router.get("/", tags=["Root"])
async def root() -> dict[str, str]:
    return {"message": "🚀 FastAPI app running on Heroku!"}


@router.get("/health", tags=["System"])
async def health_check() -> dict[str, str]:
    return {"status": "ok"}
