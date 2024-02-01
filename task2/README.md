# Task 2. Protected objects

1. Given the PC/RAM architecture: <div style="margin: 20px; text-align: center;">
   <img src="docs/architecture.svg" alt="architecture" width="500"></div>
2. Task to calculate: A = max(Z) * E + d * min(Z) * T * (MO * MK)
   - A, Z, E, T: Vector 
   - MO, MK: Matrix 
   - d: Integer
3. Programming language: Ada
    - Thread communication means: protected object

---

# Solution

### 1. Parallel mathematical algorithm:

1. m<sub>min<sub>i</sub></sub> = min ( Z<sub>h</sub> );  i = {1..4}
2. m<sub>min</sub> = min ( m<sub>min</sub> ; m<sub>min<sub>i</sub></sub> ); i = {1..4}
3. m<sub>max<sub>i</sub></sub> = max ( Z<sub>h</sub> ); i = {1..4}
4. m<sub>max</sub> = max ( m<sub>max</sub> ; m<sub>max<sub>i</sub></sub> ); i = {1..4}
5. A<sub>h</sub> = m<sub>max</sub> * E<sub>h</sub> + d * m<sub>min</sub> * T (MO<sub>h</sub> * MK)
   - shared resources: d, T, MK,  m<sub>min</sub> , m<sub>max</sub>

### 2. Developing the algorithm for each thread

| T1                                                                                                                                                                                          |                                                 | 
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------:|
| 1. Input `Z`, `E`                                                                                                                                                                           |                                                 | 
| 2. Signal T2 T3 T4 about the input completion of `Z` and `E`                                                                                                                                | S<sub>2;1</sub> S<sub>3;2</sub> S<sub>4;3</sub> | 
| 3. Wait for a signal from T2 and from T4 indicating the inputs completion                                                                                                                   |         W<sub>2;1</sub> W<sub>4;2</sub>         |
| 4. Calculate m<sub>min<sub>i</sub></sub> = min ( Z<sub>h</sub> )                                                                                                                            |                                                 |
| 5. Calculate: m<sub>min</sub> = min (m<sub>min</sub> ; m<sub>min<sub>1</sub></sub>)                                                                                                         |                                                 |
| 6. Calculate: m<sub>max<sub>1</sub></sub> = max ( Z<sub>h</sub> )                                                                                                                           |                                                 |
| 7. Calculate: m<sub>max</sub> = max (m<sub>max</sub> ; m<sub>max<sub>1</sub></sub>)                                                                                                         |                                                 |
| 8. Signal T2 T3 T4 about calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                                                      | S<sub>2;4</sub> S<sub>3;5</sub> S<sub>4;6</sub> |
| 9. Wait for a signal from T2 T3 and T4 indicating the calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                         | W<sub>2;3</sub> W<sub>3;4</sub> W<sub>4;5</sub> |
| 10. Copy:<br/>• m<sub>min<sub>1</sub></sub> = m<sub>min</sub><br/>• m<sub>max<sub>1</sub></sub> = m<sub>max</sub><br/>• d<sub>1</sub> = d<br/>• T<sub>1</sub> = T<br/>• MK<sub>1</sub> = MK |                       CS                        |
| 11. Calculate: A<sub>h</sub> = m<sub>max<sub>1</sub></sub> * E<sub>h</sub> + d<sub>1</sub> * m<sub>min<sub>1</sub></sub> * T (MO<sub>h</sub> * MK<sub>1</sub>)                              |                                                 |
| 12. Wait for a signal from T2 T3 T4 indicating the calculation completion of A<sub>h</sub>                                                                                                  | W<sub>2;6</sub> W<sub>3;7</sub> W<sub>4;8</sub> |
| 13. Output A                                                                                                                                                                                |                                                 |

<br/>

| T2                                                                                                                                                                                          |                                                 | 
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------:|
| 1. Input `d`, `MO`                                                                                                                                                                          |                                                 | 
| 2. Signal T1 T3 T4 about input of `d` and `MO`                                                                                                                                              | S<sub>1;1</sub> S<sub>3;2</sub> S<sub>4;3</sub> | 
| 3. Wait for a signal from T1 and from T4 indicating the inputs completion                                                                                                                   |         W<sub>1;1</sub> W<sub>4;2</sub>         |
| 4. Calculate m<sub>min<sub>i</sub></sub> = min ( Z<sub>h</sub> )                                                                                                                            |                                                 |
| 5. Calculate: m<sub>min</sub> = min (m<sub>min</sub> ; m<sub>min<sub>1</sub></sub>)                                                                                                         |                                                 |
| 6. Calculate: m<sub>max<sub>1</sub></sub> = max ( Z<sub>h</sub> )                                                                                                                           |                                                 |
| 7. Calculate: m<sub>max</sub> = max (m<sub>max</sub> ; m<sub>max<sub>1</sub></sub>)                                                                                                         |                                                 |
| 8. Signal T1, T3 and T4 about calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                                                 | S<sub>1;4</sub> S<sub>3;5</sub> S<sub>4;6</sub> |
| 9. Wait for a signal from T1 T3 and T4 indicating the calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                         | W<sub>1;3</sub> W<sub>3;4</sub> W<sub>4;5</sub> |
| 10. Copy:<br/>• m<sub>min<sub>1</sub></sub> = m<sub>min</sub><br/>• m<sub>max<sub>1</sub></sub> = m<sub>max</sub><br/>• d<sub>1</sub> = d<br/>• T<sub>1</sub> = T<br/>• MK<sub>1</sub> = MK |                       CS                        |
| 11. Calculate: A<sub>h</sub> = m<sub>max<sub>1</sub></sub> * E<sub>h</sub> + d<sub>1</sub> * m<sub>min<sub>1</sub></sub> * T (MO<sub>h</sub> * MK<sub>1</sub>)                              |                                                 |
| 12. Signal T1 about calculation completion of A<sub>h</sub>                                                                                                                                 |                 S<sub>1;7</sub>                 |

<br/>

| T3                                                                                                                                                                                         |                                                 | 
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------:|
| 1. Wait for a signal from T1 T2 and T4 indicating the inputs completion                                                                                                                    | W<sub>1;1</sub> W<sub>2;2</sub> W<sub>4;3</sub> |
| 2. Calculate m<sub>min<sub>i</sub></sub> = min (Z<sub>h</sub>)                                                                                                                             |                                                 |
| 3. Calculate: m<sub>min</sub> = min (m<sub>min</sub> ; m<sub>min<sub>1</sub></sub>)                                                                                                        |                                                 |
| 4. Calculate: m<sub>max<sub>1</sub></sub> = max ( Z<sub>h</sub> )                                                                                                                          |                                                 |
| 5. Calculate: m<sub>max</sub> = max (m<sub>max</sub> ; m<sub>max<sub>1</sub></sub>)                                                                                                        |                                                 |
| 6. Signal T1 T2 T4 about calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                                                     | S<sub>1;1</sub> S<sub>2;2</sub> S<sub>4;3</sub> |
| 7. Wait for a signal from T1 T2 and T4 indicating the calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                        | W<sub>1;4</sub> W<sub>2;5</sub> W<sub>4;6</sub> |
| 8. Copy:<br/>• m<sub>min<sub>1</sub></sub> = m<sub>min</sub><br/>• m<sub>max<sub>1</sub></sub> = m<sub>max</sub><br/>• d<sub>1</sub> = d<br/>• T<sub>1</sub> = T<br/>• MK<sub>1</sub> = MK |                       CS                        |
| 9. Calculate: A<sub>h</sub> = m<sub>max<sub>1</sub></sub> * E<sub>h</sub> + d<sub>1</sub> * m<sub>min<sub>1</sub></sub> * T (MO<sub>h</sub> * MK<sub>1</sub>)                              |                                                 |
| 10. Signal T1 about calculation completion of A<sub>h</sub>                                                                                                                                |                 S<sub>1;7</sub>                 |

<br/>

| T4                                                                                                                                                                                          |                                                 | 
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------:|
| 1. Input `T`, `MK`                                                                                                                                                                          |                                                 | 
| 2. Signal T1 T2 T3 about the input completion of `T` and `MK`                                                                                                                               | S<sub>1;1</sub> S<sub>2;2</sub> S<sub>3;3</sub> | 
| 3. Wait for a signal from T1 and from T2 indicating the inputs completion                                                                                                                   |         W<sub>1;1</sub> W<sub>2;2</sub>         |
| 4. Calculate m<sub>min<sub>i</sub></sub> = min ( Z<sub>h</sub> )                                                                                                                            |                                                 |
| 5. Calculate: m<sub>min</sub> = min (m<sub>min</sub> ; m<sub>min<sub>1</sub></sub>)                                                                                                         |                                                 |
| 6. Calculate: m<sub>max<sub>1</sub></sub> = max ( Z<sub>h</sub> )                                                                                                                           |                                                 |
| 7. Calculate: m<sub>max</sub> = max (m<sub>max</sub> ; m<sub>max<sub>1</sub></sub>)                                                                                                         |                                                 |
| 8. Signal T1 T2 T3 about calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                                                      | S<sub>1;4</sub> S<sub>2;5</sub> S<sub>3;6</sub> |
| 9. Wait for a signal from T1 T2 and T3 indicating the calculation completion of m<sub>min</sub> and m<sub>max</sub>                                                                         | W<sub>1;3</sub> W<sub>2;4</sub> W<sub>3;5</sub> |
| 10. Copy:<br/>• m<sub>min<sub>1</sub></sub> = m<sub>min</sub><br/>• m<sub>max<sub>1</sub></sub> = m<sub>max</sub><br/>• d<sub>1</sub> = d<br/>• T<sub>1</sub> = T<br/>• MK<sub>1</sub> = MK |                       CS                        |
| 11. Calculate: A<sub>h</sub> = m<sub>max<sub>1</sub></sub> * E<sub>h</sub> + d<sub>1</sub> * m<sub>min<sub>1</sub></sub> * T (MO<sub>h</sub> * MK<sub>1</sub>)                              |                                                 |
| 10. Signal T1 about calculation completion of A<sub>h</sub>                                                                                                                                 |                 S<sub>1;7</sub>                 |

### 3. Schema of the thread interaction: 

<div style="margin: 30px; text-align: center;">
   <img src="./docs/sync-monitor.png" alt="Synchronization monitor" width="800">
</div>

<div style="margin: 30px; text-align: center;">
   <img src="./docs/data-monitor.png" alt="Data monitor" width="800">
</div>

### 4. [Code listing](./solution.adb)