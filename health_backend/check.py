import asyncio
import asyncpg

async def test_plain():
    try:
        conn = await asyncpg.connect(
            "postgresql://neondb_owner:npg_MPmbud8qy6tN@ep-falling-king-aguwtp97-pooler.c-2.eu-central-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
        )
        result = await conn.fetchval("SELECT 1")
        print("Plain asyncpg success! Result:", result)
        await conn.close()
    except Exception as e:
        print("Plain asyncpg failed:", str(e))

asyncio.run(test_plain())