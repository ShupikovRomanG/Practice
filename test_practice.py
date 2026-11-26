import unittest

from case01.main import negative_sum_between_extremes
from case02.main import GuidedTour, Tour


class ArrayTests(unittest.TestCase):
    def test_bounds_and_values(self):
        cases = (
            ([4, -2, 10, -3, -8, 6], -3),
            ([-9, -4, 2, -1, 7], -5),
            ([2, -5, 9], 0),
            ([2, 3, 5], 0),
            ([-4], 0),
            ([-2, -2, -2], 0),
            ([5, -1, 5, -9, -9], -1),
            ([-7, -4, -3, -1], -7),
        )
        for values, expected in cases:
            with self.subTest(values=values):
                self.assertEqual(negative_sum_between_extremes(values), expected)

    def test_empty_array(self):
        with self.assertRaises(ValueError):
            negative_sum_between_extremes([])


class TourTests(unittest.TestCase):
    def test_base(self):
        tour = Tour("Казань", 15000)
        self.assertEqual(tour.description(), "Казань")
        self.assertEqual(tour.total_price(), 15000)

    def test_derived(self):
        tour = GuidedTour("Казань", 15000, 2500)
        self.assertIsInstance(tour, Tour)
        self.assertEqual(tour.description(), "Казань (с гидом)")
        self.assertEqual(tour.total_price(), 17500)
        self.assertEqual(tour.guide_cost(), 2500)

    def test_invalid_prices(self):
        with self.assertRaises(ValueError):
            Tour("Казань", -1)
        with self.assertRaises(ValueError):
            GuidedTour("Казань", 15000, -1)


if __name__ == "__main__":
    unittest.main()
