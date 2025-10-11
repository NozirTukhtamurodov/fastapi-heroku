from dataclasses import dataclass


@dataclass
class Settings:
    app_name: str = "FastAPI Heroku Demo"
    debug: bool = False


settings = Settings()
