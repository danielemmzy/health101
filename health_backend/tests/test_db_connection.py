
import asyncio
from sqlalchemy import text
from app.database import engine

async def test_connection():
    try:
        async with engine.connect() as conn:
            result = await conn.execute(text("SELECT 1"))
            print("Connection successful! Result:", result.scalar())
    except Exception as e:
        print("Connection failed:", str(e))
    finally:
        await engine.dispose()

if __name__ == "__main__":
    asyncio.run(test_connection())