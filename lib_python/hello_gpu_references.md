# Build path

📖 [pycuda: nvcc compitalation of kernel.cu failed](https://stackoverflow.com/questions/42286339/pycuda-nvcc-compitalation-of-kernel-cu-failed)  

Input:  

```shell
where cl
```

Output:  

```plaintext
C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.35.32215\bin\Hostx64\x64\cl.exe
```

なら、 `C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.35.32215\bin\Hostx64\x64` を  
ユーザー環境変数 `Path` へ入れること  

# Code

```shell
cd lib_python
hello_gpu.bat
```

* Set environment variables
* Run python script

# References

👇 没。ビルドパスを設定した方がいい  

```bat
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
echo Hello GPU
echo =========
python hello_gpu.py
```

📖 [バッチファイルが途中で終了する場合](https://qiita.com/keyta/items/e8783c212916cfbaaba5#:~:text=%E3%81%93%E3%82%8C%E3%81%AF%E3%80%813%E8%A1%8C%E7%9B%AE%E3%81%A7b.bat%E3%81%8C%E5%91%BC%E3%81%B3%E5%87%BA%E3%81%95%E3%82%8C%E3%81%9F%E9%9A%9B%E3%81%ABa.bat%E3%81%AB%E5%87%A6%E7%90%86%E3%81%8C%E6%88%BB%E3%82%89%E3%81%9A%E3%80%81%E7%B5%82%E4%BA%86%E3%81%97%E3%81%A6%E3%81%97%E3%81%BE%E3%81%86%E3%81%9F%E3%82%81%E3%81%A7%E3%81%99%E3%80%82,%E3%81%9D%E3%81%AE%E3%81%9F%E3%82%81%E3%80%81%E6%9C%AC%E6%9D%A5%E6%9C%9F%E5%BE%85%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E6%8C%AF%E3%82%8B%E8%88%9E%E3%81%84%E3%82%92%E5%AE%9F%E7%8F%BE%E3%81%99%E3%82%8B%E3%81%9F%E3%82%81%E3%81%AB%E3%81%AF%E3%80%81%E3%83%90%E3%83%83%E3%83%81%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%84%E3%82%B5%E3%83%96%E3%83%AB%E3%83%BC%E3%83%81%E3%83%B3%E3%82%92%E5%91%BC%E3%81%B3%E5%87%BA%E3%81%99%E3%81%A8%E3%81%8D%E3%81%AB%E7%94%A8%E3%81%84%E3%82%8Bcall%E3%82%92%E5%88%A9%E7%94%A8%E3%81%97%E3%81%BE%E3%81%99%E3%80%82%20%E6%9C%80%E5%88%9D%E3%81%AB%E5%AE%9F%E8%A1%8C%E3%81%97%E3%81%9F%E3%83%90%E3%83%83%E3%83%81%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AB%E5%87%A6%E7%90%86%E3%82%92%E6%88%BB%E3%81%99%E3%81%9F%E3%82%81%E3%81%AB%E3%81%AF%E3%80%81call%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%82%92%E7%94%A8%E3%81%84%E3%81%A6%E4%BB%A5%E4%B8%8B%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB%E8%A8%98%E8%BF%B0%E3%81%97%E3%81%BE%E3%81%99%E3%80%82)  
