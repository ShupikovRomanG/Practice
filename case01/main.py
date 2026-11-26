def negative_sum_between_extremes(values: list[int]) -> int:
    """Суммирует отрицательные числа между первыми вхождениями экстремумов."""
    if not values:
        raise ValueError("Массив должен содержать хотя бы один элемент.")

    min_index = 0
    max_index = 0
    for index, value in enumerate(values):
        if value < values[min_index]:
            min_index = index
        if value > values[max_index]:
            max_index = index

    left, right = sorted((min_index, max_index))
    total = 0
    for index in range(left + 1, right):
        if values[index] < 0:
            total += values[index]
    return total


def main() -> int:
    try:
        length = int(input("Размер массива N: "))
    except ValueError:
        print("Ошибка ввода. Размер массива должен быть целым числом.")
        return 1
    except EOFError:
        print("Ошибка ввода. Укажите размер массива.")
        return 1

    if length < 1:
        print("Ошибка ввода. Размер массива должен быть больше нуля.")
        return 1

    try:
        elements = input("Элементы через пробел: ").split()
        if len(elements) != length:
            print(f"Ошибка ввода. Ожидалось {length} чисел, получено {len(elements)}.")
            return 1
        values = [int(element) for element in elements]
    except ValueError:
        print("Ошибка ввода. Все элементы массива должны быть целыми числами.")
        return 1
    except EOFError:
        print("Ошибка ввода. Введите элементы массива.")
        return 1

    print(f"Сумма отрицательных элементов: {negative_sum_between_extremes(values)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
