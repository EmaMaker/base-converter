def decimalToBase(num, base):
    negative = num < 0

    if negative:
        num *= -1

    if base == "BCD":
        result = ""

        while num != 0:
            digit = int(num) % 10
            digit_conv = decimalToBase(digit, 2)
            result = "0"*(4-len(digit_conv)) + digit_conv + result

            num = (int) (num / 10)
    
    elif base == "2CP":
        part_result = decimalToBase(num, 2)

        if negative:
            result = "1"
            one = False
            for i in range(1, len(part_result)):
                if not(one) and part_result[i] == "1":
                    one = True

                if one and negative:
                    result += str( 1 - int(part_result[i]))
                else:
                    result += part_result[i]
        else:
            result = "0" + part_result

    else:
        base = int(base)
        num = int(num)
        lResult = []

        while num != 0:
            lResult.insert(0, num % base)
            num = int(num / base)
            
        #if an index of the list is >= 10 is replaced by an upper letter in ASCII (10-->A, 11-->B). Useful for bases > 10
        for i in range(0, len(lResult)):
            if lResult[i] >= 10:
                lResult[i] = chr(lResult[i] + 55)

        result = ''.join(str(e) for e in lResult)

    if negative and base != "2CP":
        return "-" + result
    else:
        return result


def baseToDecimal(num, base):
    if num == "":
        return 0

    negative = num[0] == '-'
    if negative:
        num = num[1:]

    if base == "BCD":
        s = ""
        exp = 0
        count = 0
        result = 0

        for i in range(len(num)-1, -1, -1):
            count += 1
            s += num[i]

            if count == 4:
                part_result = baseToDecimal(s[::-1], 2)

                if part_result > 9:
                    raise ValueError(f'Number > 9 ({s[::-1]} => {part_result}) present in BCD')
                else:
                    result += part_result * (10**exp)
                    exp += 1
                    count = 0
                    s = ""

        part_result = baseToDecimal(s[::-1], 2)
        if part_result > 9:
            raise ValueError(f'Number > 9 ({s[::-1]} => {part_result}) present in BCD')
        else:
            result += part_result * (10**exp)

    else:
        if base == "2CP":
            calc_base = 2
            if negative:
                raise ValueError(f"2CP can't have negative sign")

        else:
            calc_base = int(base)

        result = 0
        lnum = len(num)

        for i in range(0, lnum):
            exp = calc_base**(lnum-1-i)
            if("0" <= num[i] <= "9"):
                
                if int(num[i]) >= calc_base:
                    raise ValueError(f'Digit {num[i]} is >= than base {calc_base}')

                if base == "2CP" and i == 0:
                    #MSB needs to be subtracted in cp2
                    result -= int(num[i]) * exp
                else :
                    result += int(num[i]) * exp
            
            else:

                if (ord(num[i]) - 55) >= calc_base:
                    raise ValueError(f'Digit {num[i]} ({ord(num[i]) - 55}) is >= than base {calc_base}')

                #allow for bases > 10 where letters are required
                result += (ord(num[i]) - 55) * exp

    if negative:
        return -result
    else:
        return result

if __name__ == "__main__":
    number = input("Type in the number: ")
    base1 = input("Type the starting numerical base: ")
    base2 = input("Type the numerical base you want to convert it to: ")

    num1 = int(baseToDecimal(number, base1))

    print(num1)

    num_final = decimalToBase(num1, base2)

    print(f'{number} ({base1}) = {num_final}({base2})')



    # try:
    #     print(baseToDecimal("11111111", 2))
    #     print(baseToDecimal("31", 8))
    #     print(baseToDecimal("FF", 16))
    #     print(baseToDecimal("100", "2CP"))
    #     print(baseToDecimal("", 2))
    #     print(baseToDecimal("0110", "BCD"))
    #     print(baseToDecimal("110110", "BCD"))
    #     print()
    #     print(baseToDecimal("-11111111", 2))
    #     print(baseToDecimal("-31", 8))
    #     print(baseToDecimal("-FF", 16))
    #     print(baseToDecimal("", 2))
    #     print(baseToDecimal("-0110", "BCD"))
    #     print(baseToDecimal("-110110", "BCD"))
    #     # print(baseToDecimal("-100", "2CP"))
    #     # print(baseToDecimal("110111", "BCD"))
    #     print()
    #     print(decimalToBase(127, "2CP"))
    #     print(decimalToBase(-4, "2CP"))
    #     print(decimalToBase(169, "BCD"))        
    #     print(decimalToBase(255, 2))
    #     print(decimalToBase(128, 2))
    #     print(decimalToBase(127, 2))

    # except ValueError as v:
    #     print(v)