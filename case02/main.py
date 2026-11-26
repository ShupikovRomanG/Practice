class Tour:
    def __init__(self, title: str, base_price: int) -> None:
        if base_price < 0:
            raise ValueError("Цена должна быть неотрицательной.")
        self.title = title
        self.base_price = base_price

    def description(self) -> str:
        return self.title

    def total_price(self) -> int:
        return self.base_price


class GuidedTour(Tour):
    def __init__(self, title: str, base_price: int, guide_fee: int) -> None:
        super().__init__(title, base_price)
        if guide_fee < 0:
            raise ValueError("Доплата должна быть неотрицательной.")
        self.guide_fee = guide_fee

    def description(self) -> str:
        return f"{super().description()} (с гидом)"

    def total_price(self) -> int:
        return super().total_price() + self.guide_fee

    def guide_cost(self) -> int:
        return self.guide_fee


def main() -> None:
    basic = Tour("Казань", 15000)
    guided = GuidedTour("Казань", 15000, 2500)
    for tour in (basic, guided):
        print(f"{tour.description()}: {tour.total_price()} руб.")
    print(f"Услуга гида: {guided.guide_cost()} руб.")


if __name__ == "__main__":
    main()
