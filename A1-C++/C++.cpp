//============================================================================
// Name        : CSC.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
#include <algorithm>
#include <vector>
#include <string>
#include <sstream>

using namespace std;

// for test use
void print (vector<int> const& input){
	for (unsigned int i=0; i < input.size(); i++){
		cout<< input.at(i) <<' ';
	}
	cout<<endl;
}

vector<int> lis(vector<int> const& list) { // & list -> make an alias

    int n = list.size();

    vector<int> subsequence;

    if (n>= 1){
		const int infinite = 100000000;
		//Index of corresponding value is stored in the array
		vector<int> indexAtIndexLength(n+1, infinite);
		//read value is stored in the array
		vector<int> valueAtIndexLength(n+1, infinite);
		// index 0 is preserved
		indexAtIndexLength[0] = -infinite;
		valueAtIndexLength[0] = -infinite;


		// same length as original list, store the index of best previous (smaller) number
		vector<int> ancestorIndex(n, -1);

		for (int i = 0; i < n; i++) {
			// j is the index (in original array) of the number that is just larger than current number (list[i])
			int j = upper_bound(valueAtIndexLength.begin(), valueAtIndexLength.end(), list[i]) - valueAtIndexLength.begin();

			// either overwrite current (index) number or overwrite infinite
			if (valueAtIndexLength[j-1] != list[i]){
				//update index/value at index length
				indexAtIndexLength[j] = i;
				valueAtIndexLength[j] = list[i];
				//update ancestor index
				ancestorIndex[i] = indexAtIndexLength[j-1];
			}
			//if ==, repeated number,  no need to consider that
		}


		// find last non-infinite index in indexAtIndexLength
		int non_infinite_index;
		for (int i = 0; i <= n; i++) {
			if (indexAtIndexLength[i] < infinite){
				non_infinite_index = indexAtIndexLength[i];
			}
		}

		//find the longest increasing subsequence
		subsequence.insert(subsequence.begin(), list[non_infinite_index]);
		//start from the end of array and trace back to find all longest increasing subsequence
		int ancestor_index = ancestorIndex[non_infinite_index];
		while (ancestor_index != -100000000){
			subsequence.insert(subsequence.begin(), list[ancestor_index]);
			ancestor_index = ancestorIndex[ancestor_index];
		}
		return subsequence;
    }
    return subsequence;
}


int main() {

	string stringInput;
	getline(cin, stringInput);

	//process input string
	stringstream input(stringInput);
	int i = 0;
	vector<int> list;
	while (input >> i) {
		list.push_back(i);
	}

	// get and print result
	vector<int> subsequence = lis(list) ;
	print(subsequence);


	return 0;
}
