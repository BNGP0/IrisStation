/*
pseudo-random number generator
given the same seed and the same min and max values, it should always return the same seemingly random result.

warning: it is possible this would only work with positive integers

if you're going to change this code, announce it to the players because all of the seeds will be changed
*/

// TESTED, IT SAYS THERE ARE INDEXES OUT OF BOUNDS SOMEWHERE IN THE pseudo_random_mod()
// maybe i shouldn't add 1 to the range variable? i think there weren't bugs in prand simple

// very simple pseudo-randomiser, rather easy to predict but can be used in more complex ones
/proc/pseudo_random_simple(seed = 0, min = 0, max = 10)
// if the range consists of only one number, return it
	if (min == max)
		return max

	if (seed == 0)
		seed = 1 // to avoid devided by zero errors. No idea why they appeared in the C# version
	var range = max - min

	var result = ((11*seed)%3 + (7*seed)%5 + (5*seed)%7 +(3*seed)%11)%range + min

	return result



/proc/pseudo_random_mod(seed = 0, min = 0, max = 10)
// if the range consists of only one number, return it
	if (min == max)
		return max

	if (seed == 0)
		seed = 1 // to avoid devided by zero errors

	var range = max - min + 1

	var/list/primes = list(29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97) //not all of them but enough for the generator

	var/p1 = primes[pseudo_random_simple(seed, 1, primes.len)] //made lists start from 1 instead of 0 because debugging said this line had an index out of range
	var/p2 = primes[pseudo_random_simple(seed + 11, 1, primes.len)]
	var/p3 = primes[pseudo_random_simple(seed+ 101, 1, primes.len)]
	var/p4 = primes[pseudo_random_simple(seed+ 1009, 1, primes.len)]

//	var result = (seed%p1 + (10 * seed)%p2 + (100 * seed)%p3 +(1000 * seed)%p4)%range + min
	var result = (seed%p1 + seed%p2 + seed%p3 +seed%p4)%range + min

	return result



// The item for checking results of the RNG
/obj/item/debug/rng_tester
	name = "RNG debugger"
	desc = "Generates a sequence of random numbers to test the random number generated. Minimum and maximum numbers are changed through view variables if needed."
	icon = 'icons/obj/weapons/club.dmi'
	icon_state = "hypertool"
	inhand_icon_state = "hypertool"
	var/rng_min = 0
	var/rng_max = 10
	var/rng_seed_from = 1
	var/rng_seed_to = 50
	var/show_numbers_instead_of_distribution = FALSE


/obj/item/debug/rng_tester/attack_self(mob/user)
	..()
	if (show_numbers_instead_of_distribution)
		for(var/i=rng_seed_from, i<rng_seed_to, i++)
			var/number = pseudo_random_mod(i,rng_min,rng_max)
			to_chat(user, span_warning("The randomly generated number is: " + number))
	else
//		var/range = rng_max-rng_min
//		var/list/distribution = new/list(range + 1)
//// should be enough for most tests, the extra values could just go unused if needed
		var/list/distribution = list(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,)
/*
// changes nulls into zeros so you can do math with them
		for(var/null_variable in distribution)
			null_variable = 0
*/
//counting the random numbers
		for(var/i=rng_seed_from, i<rng_seed_to, i++)
//			var/r_number = pseudo_random_mod(i,rng_min,rng_max)
			distribution[pseudo_random_mod(i,rng_min,rng_max)] += 1
//output the distribution when the counting is done
		for(var/dist_number in distribution)
			to_chat(user, span_warning("The number [dist_number] appears [distribution[dist_number]] times." ))







// the same algorhitm rewritten in C# because it was slightly faster to debug
/*

// Online C# Editor for free
// Write, Edit and Run your C# code using C# Online Compiler

using System;

public class HelloWorld
{
    public static void Main(string[] args)
    {
        int[] results = new int[11] {0,0,0,0,0,0,0,0,0,0,0};
        for (int i = 1200; i < 2000; i++)
        {
        int prand = pseudo_random_mod(i,0,10);
//        Console.WriteLine ("Seed: ." + i +" , result: " + prand);
        results[prand] += 1;
        }
        //string res_string = "";

        for (int i = 0; i < 11; i++)
        {
            Console.WriteLine (i +" appears " + results[i] + " times");
        }

    }

    public static int pseudo_random_simple(int seed = 0, int min = 0, int max = 10)
    {
        if (min == max)
        {return max;}

        int range = max - min;

        int result = (11 * seed%3 + 7 * seed%5 + 5 * seed%7 +3 *seed%11)%range + min;
        return result;
    }



        public static int pseudo_random_mod(int seed = 0, int min = 0, int max = 10)
    {
        if (min == max)
        {return max;}
        // seed 0 gives divided by 0 errors
        if (seed ==0)
        {seed = 1;}

        int range = max - min + 1;
        int[] primes = new int[16] {29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97};
        int p1 = primes[pseudo_random_simple(seed, 0, 16)];
        int p2 = primes[pseudo_random_simple(seed + 11, 0, 16)];
        int p3 = primes[pseudo_random_simple(seed + 101, 0, 16)];
        int p4 = primes[pseudo_random_simple(seed + 1009, 0, 16)];
    //    Console.WriteLine("primes: " + p1 +" " + p2 + " " + p3 + " " +p4);

        int result = (seed%p1 + seed%p2 + seed%p3 +seed%p4)%range + min;
        return result;
    }


}

*/














