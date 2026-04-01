from pydantic import BaseModel

class CouponApply(BaseModel):
    code: str