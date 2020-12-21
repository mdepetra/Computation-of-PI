#=
PROGETTO DI ESPERIENZE DI PROGRAMMAZIONE - Sessione Estiva 2020
Calcolo della costante Pi con i vari algoritmi dei fratelli Borwein
Author: Mirko De Petra
=#

#
nbits(ndigits::Int) = ceil(Int, log(2,10) * (ndigits+1))

#=
1976: Algoritmo scoperto indipendentemente da Eugene Salamin e Richard Brent. 
Convergenza QUADRATICA
=#
function brent_salamin(ndigits::Integer)
    n = nbits(ndigits)
    setprecision(BigFloat, n) do
        err = BigFloat(10) ^ -ndigits
        a = BigFloat(1)
        b = BigFloat(1) / sqrt(BigFloat(2))
        s = BigFloat(0.5)
        pow2 = 1
        p = (2 * a ^ 2) / s
        k = 0
        while true
            pn = p
            an = a
            a = (an + b) / 2
            b = sqrt(an * b)
            c = a ^ 2 - b ^ 2
            pow2 *= 2
            s = s - pow2 * c
            p = (2 * a ^ 2) / s
            k = k + 1
            if abs(p-pn) < err break end
        end
        println("$ndigits\t$k\t$p\t$(abs(pi-p))")
        p
    end
end

#1984: Algoritmo di Borwein con convergenza QUADRATICA
function borwein_2(ndigits::Integer)
    n = nbits(ndigits)
    setprecision(BigFloat, n) do
        err = BigFloat(10) ^ -ndigits
        #Condizioni iniziali
        a = sqrt(BigFloat(2))
        b = BigFloat(0)
        p = 2 + a
        k = 0 #Contatore iterazioni
        while true
            pn = p
            arq = sqrt(a)
            b = ((1+b)*arq)/(a+b)
            a = (arq+1/arq)*0.5
            p = ((1+a)*p*b)/(1+b)
            k = k + 1
            if abs(p-pn) < err break end
        end
        println("$ndigits\t$k\t$p\t$(abs(pi-p))")
        p
    end
end

#1991: Algoritmo di Borwein con convergenza CUBICA
function borwein_3(ndigits::Integer)
    n = nbits(ndigits)
    setprecision(BigFloat, n) do
        err = BigFloat(10) ^ -ndigits
        #Condizioni iniziali
        a = BigFloat(1) / BigFloat(3)
        s = (sqrt(BigFloat(3)) - 1) / BigFloat(2)
        pow3 = 1
        p = 1/a
        r = -1 
        k = 0 #Contatore iterazioni
        while true
            pn = p
            r = 3 / (1 + 2 * ((1 - s ^ 3) ^ (1/3)))
            s = (r - 1) / 2
            rq = r ^ 2
            a = rq * a - pow3 * (rq - 1)
            pow3 *= 3
            p = 1/a
            k = k + 1
            if abs(p-pn) < err break end
        end
        println("$ndigits\t$k\t$p\t$(abs(pi-p))")
        p
    end
end

#1985: Algoritmo di Borwein con convergenza QUARTICA
function borwein_4(ndigits::Integer)
    n = nbits(ndigits)
    setprecision(BigFloat, n) do
        err = BigFloat(10) ^ -ndigits
        #Condizioni iniziali
        y = BigFloat(sqrt(BigFloat(2)) - 1)
        a = 2 * (y ^ 2)
        pow2 = 8 #2^3
        p = 1/a
        k = 0 #Contatore iterazioni
        while true
            pn=p
            yk = (1 - y ^ 4) ^ (0.25)
            y = (1-yk)/(1+yk)
            a = a * ((1+y)^4) - pow2 * y * (1 + y + y ^ 2)
            pow2 *= 4
            p = 1/a
            k = k + 1
            if abs(p-pn) < err break end
        end
        println("$ndigits\t$k\t$p\t$(abs(pi-p))")
        p
    end
end

#Algoritmo di Borwein con convergenza QUINTICA
function borwein_5(ndigits::Integer)
    n = nbits(ndigits)
    setprecision(BigFloat, n) do
        err = BigFloat(10) ^ -ndigits
        #Condizioni iniziali
        a = BigFloat(0.5)
        s = 5 * (sqrt(BigFloat(5))-2)
        pow5 = 1
        k = 0 #Contatore iterazioni
        p = 1/a
        while true
            pn = p
            x = 5 / s - 1
            y = (x - 1) ^ 2 + 7
            z = (x / 2 * (y + sqrt(y^2 - 4 * x^3))) ^ (0.2)
            sq = s ^ 2
            a = sq * a - pow5 * ((sq - 5) / 2 + sqrt(s * (sq - 2*s + 5)))
            pow5 *= 5
            s = 25 / (((z + (x/z) + 1) ^ 2) * s) 
            p = 1/a
            k = k + 1
            if abs(p-pn) < err break end
        end
        println("$ndigits\t$k\t$p\t$(abs(pi-p))")
        p
    end
end

#Algoritmo di Borwein con convergenza NONICA
function borwein_9(ndigits::Integer)
    n = nbits(ndigits)
    setprecision(BigFloat, n) do
        #Condizioni iniziali
        k = 0 #Contatore iterazioni
        err = BigFloat(10) ^ -ndigits
        a = BigFloat(1) / BigFloat(3)
        r = (sqrt(BigFloat(3)) - 1) / BigFloat(2)
        s = (1 - r^3) ^ (1/3)
        pow3 = a
        p = 0
        k = 0 #Contatore iterazioni
        while true
            pn = p
            t = 1 + 2 * r
            u = (9 * r * (1 + r + r^2)) ^ (1/3)
            v = t^2 + t * u + u^2
            w = (27 * (1 + s + s^2)) / v
            a = w * a + pow3 * (1 - w)
            pow3 *= 9
            s = ((1-r)^3) / ((t + 2 * u) * v)
            r = (1 - s^3) ^ (1/3)
            p = 1/a
            k = k + 1
            if abs(p-pn) < err break end
        end
        println("$ndigits\t$k\t$p\t$(abs(pi-p))")
        p
    end
end

function testBS()
    println("BRENT SALAMIN")
    @time brent_salamin(1000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time brent_salamin(100000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time brent_salamin(1000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time brent_salamin(10000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time brent_salamin(50000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time brent_salamin(100000000)
    println("--------------------------------------------------------------------------------------------------------------")
    println("--------------------------------------------------------------------------------------------------------------")
end

function testB2()
    println("BORWEIN 2")
    @time borwein_2(1000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_2(100000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_2(1000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_2(10000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_2(50000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_2(100000000)
    println("--------------------------------------------------------------------------------------------------------------")
    println("--------------------------------------------------------------------------------------------------------------")
end

function testB3()
    println("BORWEIN 3")
    @time borwein_3(1000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_3(100000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_3(1000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_3(10000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_3(50000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_3(100000000)
    println("--------------------------------------------------------------------------------------------------------------")
    println("--------------------------------------------------------------------------------------------------------------")
end

function testB4()
    println("BORWEIN 4")
    @time borwein_4(1000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_4(100000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_4(1000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_4(10000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_4(50000000)
    println("--------------------------------------------------------------------------------------------------------------")
    @time borwein_4(100000000)
    println("--------------------------------------------------------------------------------------------------------------")
    println("--------------------------------------------------------------------------------------------------------------")
end

#=
Test dei Borwein 
=#
function testBorwein()
    println("ndigits\titer\tpi\terror")
    testB2()
    testB4()
end

#=
Test 
=#
function test()
    println("ndigits\titer\tpi\terror")
    testBS()
    testB2()
    testB3()
    testB4()
end
