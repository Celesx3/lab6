# Lab 6 Нэгдүгээр эрэмбийн логик

pyDatalog болон Prolog ашигласан гэр бүлийн мэдлэгийн сан. Үндсэн 8 алхам,
хоёр нэмэлт даалгавар, асуултын хүснэгт болон FOL тайлбар багтсан.

Зааврын PDF нь `Lab6_FOL_Заавар.pdf` нэртэй боловч дотор нь notebook-ийг
`Lab4_FOL.ipynb` гэж нэрлэхийг шаардсан тул тэр нэрийг хадгалсан.

## Файлууд

- `Lab4_FOL.ipynb` — код, монгол тайлбар, ажиллуулсан гаралт, 70 шалгалт.
- `family.pl` — Prolog баримт, дүрэм болон нэмэлт гишүүний туршилт.
- `family_tests.pl` — 45 SWI-Prolog PL-Unit тест.
- `requirements.txt` — notebook ажиллуулах Python сангууд.
- `requirements-lab4.txt` — pyDatalog-ийн тусдаа хувилбарын шаардлага.
- `output/lab4_fol/prolog_validation.json` — хадгалсан Prolog шалгалтын үр дүн.

## Python болон Jupyter ажиллуулах

Python 3.12 орчинд шалгасан. Windows PowerShell дээр:

```powershell
git clone https://github.com/Celesx3/lab6.git
cd lab6
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m ipykernel install --sys-prefix --name lab1 --display-name "Python (Lab 1)"
.\.venv\Scripts\python.exe -m jupyterlab Lab4_FOL.ipynb
```

**Python (Lab 1)** kernel сонгоод **Restart Kernel and Run All Cells** командыг
ажиллуулна. Нэмэлт Dulguun гишүүнийг туршилтын дараа хасаж, үндсэн санг сэргээнэ.

## Prolog ажиллуулах

SWI-Prolog суусан орчинд:

```text
swipl -s family.pl
```

Жишээ асуултууд:

```prolog
setof(X, ancestor(X,temuulen), S).
setof(X, childless(X), S).
findall(Y, sibling(oyuna,Y), L), length(L,N), sort(L,S).
add_dulguun, setof(X,sibling(X,temuulen),S), remove_dulguun.
```

Бүх тест:

```text
swipl -q -s family_tests.pl -g run_tests -t halt
```

SWI-Prolog суулгаагүй бол [SWISH](https://swish.swi-prolog.org/)-д `family.pl`-ийг
оруулж асуултуудыг туршиж болно. Онлайн орчны эрхээс хамаарч dynamic баримт
өөрчлөх нэмэлт туршилт хязгаарлагдаж болно.

## Шалгасан үр дүн

| Холбоо | Ялгаатай хариуны тоо |
|---|---:|
| person | 15 |
| parent | 18 |
| grandparent | 12 |
| sibling | 10 |
| cousin | 16 |
| ancestor | 32 |
| childless | 5 |
| spouse | 10 |
| uncle_in_law | 3 |
| aunt_in_law | 7 |

Notebook-ийн 70 шалгалт, SWI-Prolog-ийн 45 тест давсан. 25 предикатын бүх
ялгаатай tuple-ийг pyDatalog, SWI-Prolog болон тусдаа Python графын тооцооллоор
тулгахад бүрэн тохирсон. Шалгасан хувилбар: Python 3.12.14, pyDatalog 0.22.4,
SWI-Prolog 10.1.18, албан ёсны swipl-wasm 8.2.3.

Эцэг эхийн граф циклгүй. `childless` нь CWA-ийн дагуу санд бүртгэлтэй хүүхэдгүй
гэсэн утгатай; мэдээлэл дутуу үед бодит амьдралын хүүхэдгүйг батлахгүй.
