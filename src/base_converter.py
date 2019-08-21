MAX_BASE = 16
MIN_BASE = 1


def decimal_to_base(snum, sbase):
    # check if number is negative
    neg = str(snum).startswith("-");
    if neg:
        snum = snum[1:]

    if sbase == "BCD":

        lnum = list(snum)
        lnewnum = []

        for i in range(0, len(lnum) ):
            # converts every digit into a 4bit binary number
            bcd = decimal_to_base(snum[i], "2")
            bcd = list(bcd)
            bcd.reverse()

            # adds as many 0s and needed if numbers is shorter that 4bit
            for j in range(0, 4 - len(bcd)):
                bcd.append("0")

            # reversed the list
            bcd.reverse()
            # adds the numbers in the list
            for j in bcd:
                lnewnum.append(j)
        if neg:
            lnewnum.reverse()
            lnewnum.append('-')
            lnewnum.reverse()

        return ''.join(str(n) for n in lnewnum)

    elif sbase == "CP2":
        # Two's Complements

        # first converts the number in binary
        lbin = list(decimal_to_base(snum, "2"))
        lbin.reverse()

        # appending a zero as Most Important Bit means that the number is positive. Has to be done by default
        lbin.append("0")
        lbin.reverse()

        # If the number is negative it goes on with the conversion
        # starting from right, all digits stay the same until the first 1 is reached
        # after that all digits are logically negated

        if neg:
            lbinneg = []
            got_one = False
            lbin.reverse()
            for e in lbin:
                if not got_one:
                    lbinneg.append(e)
                    if e == '1':
                        got_one = True
                else:
                    lbinneg.append(1 - int(e))

            lbinneg.reverse()
            return ''.join(str(n) for n in lbinneg)

        return ''.join(str(n) for n in lbin)

    else:

        dnum = int(snum)
        result = []
        while dnum != 0:
            result.append(dnum % int(sbase))
            dnum = int(dnum / int(sbase))

        for i in range(0, len(result)):
            c = result[i]
            if c >= 10:
                result[i] = chr(c + 55)

        if neg:
            result.append('-')
        result.reverse()
        return ''.join(str(n) for n in result)

########################################################################################################################


def base_to_decimal(snum, sbase):
    # check if number is negative
    neg = str(snum).startswith("-");
    if neg:
        snum = snum[1:]

    if sbase == "BCD":
        # Binary Coded Decimal

        num = []
        # checks every 4 numbers, as BCD translates a decimal number into a 4bit binary one
        for i in range(0, len(snum), 4):
            s = []
            s.append(snum[i+0])
            s.append(snum[i+1])
            s.append(snum[i+2])
            s.append(snum[i+3])

            # translates the 4bit binary number into it's decimal corrispondent, and then adds it to the list
            s1 = ''.join(str(e) for e in s)
            num.append(base_to_decimal(s1, "2"))

        if neg:
            num.reverse()
            num.append('-')
            num.reverse()

        # returns the list a single string for the number
        return ''.join(str(e) for e in num)

    elif sbase == "CP2":
        # Two's Complement

        # Same as converting binary -> decimal, but the sign bit (most important bit) as to be subtracted. This can be
        # done both if the number is negative (1) or positive (0). In this case, the last bit will be multiplied by 0
        # and nullified

        lnum = list(snum)
        lnum.reverse()

        result = 0
        for i in range(0, len(lnum)):
            if i == len(lnum) - 1:
                result -= int(lnum[i]) * pow(2, i)
            else:
                result += int(lnum[i]) * pow(2, i)

        return str(result)

    else:
        # numeric bases
        # for every char in the string, make it an int. If it's a letter, translate it into ASCII int for the letter
        # and subtract 55  (A-->10 and so on)
        lnum = []
        for c in snum:
            try:
                c1 = int(c)
            except ValueError:
                c1 = ord(c) - 55
            lnum.append(c1)
        lnum.reverse()

        # make up the result
        result = 0
        for i in range(0, len(lnum)):
            result += (lnum[i] * pow(int(sbase), i))

        # negate if necessary
        if neg:
            result *= -1

        return str(result)

########################################################################################################################


def convert_base(snum, sbase, snewbase):
    s = base_to_decimal(snum, sbase)
    return decimal_to_base(s, snewbase)

########################################################################################################################


def inputs():
    s = input("Type the number you want to convert: ").upper()

    s1 = input("Now type its base. (Remember that a base can only use numbers from 0 up to (base - 1): ")

    highest_digit = 0
    for sD in s:
        if sD != '-':
            try:
                c1 = int(sD)
            except ValueError:
                c1 = ord(sD) - 55

            if c1 > highest_digit:
                highest_digit = c1

    try:
        while int(s1) > MAX_BASE or int(s1) <= MIN_BASE or highest_digit > int(s1):
            s1 = input("Invalid base, try again: ")
    except ValueError:
        while (s1.upper() != '' and s1.upper() != 'BCD' and s1.upper() != 'CP2') or (highest_digit > 2 and (s1.upper() == "CP2" or s1.upper() == "BCD")):
            s1 = input("Invalid base, try again: ")

    s2 = input("Now type the base you wanna convert it to: ")

    try:
        while int(s2) > MAX_BASE or int(s2) <= MIN_BASE:
            s2 = input("Invalid base, try again: ")
    except ValueError:
        while s2.upper() != '' and s2.upper() != 'BCD' and s2.upper() != 'CP2':
            s2 = input("Invalid base, try again: ")

    print(s + "(" + s1 + ") = " + str(convert_base(s, s1, s2)) + "(" + s2 + ")")

########################################################################################################################


# Start of main here
inputs()
