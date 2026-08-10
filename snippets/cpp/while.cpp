#include <iostream>
int main()
{
	int n;
	std::cin >> n;

	do // 0だととりあえず0が出力される。最初の一回は実行したいとき専用
	{
		std::cout << (n % 10) << '\n';
		n /= 10;
	} while (0 < n);
	// while (0 < n) // 0だと何も出力されない
	// {
	// 	std::cout << n % 10 << '\n';
	// 	n /= 10;
	// }
}


