MAX_BASE = 16
MIN_BASE = 1


def decimalToBase(sNum, sNewBase):
    sNewBase.capitalize()

    lNewNum = []
    dNum = int(sNum)
    
    if sNewBase == "BCD":
        for i in range(0, len(sNewBase)):
            #converts every digit into a 4bit binary number
            bcd = decimalToBase(str(list(str(sNum))[i]), "2")
            bcd = list(bcd)
            bcd.reverse()

            #adds as many 0s and needed if numbers is shorter that 4bit
            for i in range(0, 4-len(bcd)):
                bcd.append("0")

            #reversed the list
            bcd.reverse()
            #adds the numbers in the list
            for i in bcd:
                lNewNum.append(i)
    elif sNewBase == "CP2":
        lBin = list(decimalToBase(str(abs(int(dNum))), "2"))
        lBin.reverse()
        lBin.append(0)
        lBin.reverse()
            
        if dNum >= 0:
            return ''.join(str(e) for e in lBin)
        else:
            lBinNeg = []
            
            gotOne = False
            for e in lBin:
                if gotOne == False:
                    lBinNeg.append(e)
                    if e == '1':
                        gotOne = True
                    else:
                        lBinNeg.append(1 - int(e))

            lBinNeg.reverse()
            return ''.join(str(n) for n in lBinNeg)
            
                    
            
            
            
    else:
        #number divided by the base until it's 0. rests of the divisions are put in the list

        dNewBase = int(sNewBase)
        while dNum != 0:
            lNewNum.append(dNum % dNewBase)
            dNum = int(dNum / dNewBase)

        #list is reversed, like when you convert manually
        lNewNum.reverse()

        #if an index of the list is >= 10 is replaced by an upper letter in ASCII (10-->A, 11-->B). Useful for bases > 10
        for i in range(0, len(lNewNum)):
            c = lNewNum[i]
            if c >= 10:
                lNewNum[i] = chr(c + 55)

    return ''.join(str(e) for e in lNewNum)


def baseToDecimal(sNum, sBase):

    #given the base, it's translated into a base 10 number

    if sBase == "BCD":
        num = []
        #checks every 4 numbers, as BCD translates a decimal number into a 4bit binary one
        for i in range(0, len(sNum), 4):
            s = []
            s.append(sNum[i+0])
            s.append(sNum[i+1])
            s.append(sNum[i+2])
            s.append(sNum[i+3])

            #translates the 4bit binary number into it's decimal corrispondent, and then adds it to the list
            s1 = ''.join(str(e) for e in s)
            num.append(baseToDecimal(s1, "2"))

        #returns the list a single string for the number
        return ''.join(str(e) for e in num)
    elif sBase == "CP2":
        #creates empty array and cast the base to an int
        lNumbs = []
        
        #for every char in the string, make it an int. If it's a letter, translate it into ASCII int for the letter and subtract 55  (A-->10 and so on)
        for c in sNum:
            try:
                c1 = int(c)
            except ValueError:
                c1 = ord(c) - 55

            lNumbs.append(c1)

        #the list is reversed, so first digit on number is index 0
        lNumbs.reverse()

        lNum = int(0)
        #every index of the list is multiplied by the base on the number (Index 0 is base^0 and so on)
        for a in range(0, len(lNumbs)):
            if(a+1 == len(lNumbs)):
                lNum = lNum - lNumbs[a] * pow(2, a)
            else:
                lNum = lNum + lNumbs[a] * pow(2, a)
                
        return lNum        
    else:
        #creates empty array and cast the base to an int
        lNumbs = []
        dBase = int(sBase)

        #for every char in the string, make it an int. If it's a letter, translate it into ASCII int for the letter and subtract 55  (A-->10 and so on)
        for c in sNum:
            try:
                c1 = int(c)
            except ValueError:
                c1 = ord(c) - 55

            lNumbs.append(c1)

        #the list is reversed, so first digit on number is index 0
        lNumbs.reverse()

        lNum = int(0)
        #every index of the list is multiplied by the base on the number (Index 0 is base^0 and so on)
        for a in range(0, len(lNumbs)):
                lNum = lNum + lNumbs[a] * pow(dBase, a)
                
        return lNum


def convertBase(sNum, sBase, sNewBase):
    s = baseToDecimal(sNum, sBase)
    return decimalToBase(s, sNewBase)


def inputs():
    s = input("Type the number you want to convert: ")

    s1 = input("Now type its base: ")
    try:
        while int(s1) > MAX_BASE or int(s1) <= MIN_BASE:
            s1 = input("Invalid base, try again: ")
    except ValueError:
        while s1.upper() != "" and s1.upper() != "BCD" and s1.upper != "CP2":
            s1 = input("Invalid base, try again: ")

    s2 = input("Now type the base you wanna convert it to: ")

    try:
        while int(s2) > MAX_BASE or int(s2) <= MIN_BASE:
            s2 = input("Invalid base, try again: ")
    except ValueError:
        while s2.upper() != "" and s2.upper() != "BCD" and s2.upper != "CP2":
            s2 = input("Invalid base, try again: ")

    print(s + "(" + s1 + ") = " + str(convertBase(s, s1, s2)) + "(" + s2 + ")")

#inputs()
#print(decimalToBase("-2", "CP2"))
print(baseToDecimal("110", "CP2"))
