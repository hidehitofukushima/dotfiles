
class Sample:
    def __init__(self, sample_id: str, value: float) -> None:
        self.sample_id = sample_id
        self.value = value

    def doubled(self) -> float:
        return self.value * 2

    def __repr__(self) -> str:
        return f"Sample(sample_id={self.sample_id!r}, value={self.value!r})"


sample = Sample("S01", 10.0)
print(sample, sample.doubled())

