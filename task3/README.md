# Task 3. Rendezvous synchronization

1. Given the PC/RAM architecture: <div style="margin: 20px; text-align: center;">
   <img src="architecture.svg" alt="architecture" width="500"></div>
2. Task to calculate: MA = MB * d + MC * MC
    - MA, MB, MC, MK: Matrix
    - d: Integer
3. Programming language: Ada
    - Thread communication means: rendezvous mechanism

---

# Solution

### 1. Parallel mathematical algorithm:

1. MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK

### 2. Developing the algorithm for each thread

##### Thread T1 and T5
1. Accept MB<sub>h</sub> , MC<sub>h</sub> , d and MK from T2
2. Calculate MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK
3. Send MA<sub>h</sub> to T2

<br/>

##### Thread T2
1. Accept MB<sub>4h</sub> , MC<sub>4h</sub> and d from T3
2. Accept MK from T4
3. Send MB<sub>h</sub> , MC<sub>h</sub>, d and MK to T1 T4 and T5
4. Send MK to T3
5. Calculate MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK
6. Accept MA<sub>h</sub> from T1 and T5
7. Accept MA<sub>4h</sub> from T3
8. Send MA<sub>7h</sub> to T4

<br/>

##### Thread T3
1. Accept MB<sub>6h</sub> and d from T7
2. Send MB<sub>h</sub> and d to T6
3. Send MB<sub>4h</sub> and d to T2
4. Accept MC<sub>7h</sub> from T6
5. Send MC<sub>2h</sub> to T7
6. Send MC<sub>4h</sub> to T2
7. Accept MK from T2
8. Send MK to T6
9. Send MK to T7
10. Calculate MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK
11. Accept MA<sub>h</sub> from T6
12. Accept MA<sub>2h</sub> from T7
13. Send MA<sub>4h</sub> to T2

<br/>

##### Thread T4
1. Input MK
2. Send MK to T2
3. Accept MB<sub>h</sub> , d, MC<sub>h</sub> from T2
4. Calculate MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK
5. Accept MA<sub>7h</sub> from T2
6. Output MA

<br/>

##### Thread T6
1. Input MC
2. Send MC<sub>7h</sub> to T3
3. Accept MB<sub>h</sub> , d and MK from T3
4. Calculate MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK
5. Send MA<sub>h</sub> to T3

<br/>

##### Thread T7
1. Accept MB<sub>7h</sub> and d from T8
2. Accept MC<sub>2h</sub> and MK from T3
3. Send MB<sub>6h</sub> and d to T3
4. Send MC<sub>h</sub> and MK to T8
5. Calculate MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK
6. Accept MA<sub>h</sub> from T8
7. Send MA<sub>2h</sub> to T3

<br/>

##### Thread T8
1. Input MB, d
2. Send MB<sub>7h</sub> and d to T7
3. Accept MC<sub>h</sub> and MK from T7
4. Calculate MA<sub>h</sub> = MB<sub>h</sub> * d + MC<sub>h</sub> * MK
5. Send MA<sub>h</sub> to T7

### 3. Schema of the thread interaction:

<div style="margin: 20px; text-align: center;">
   <img src="synchronization.png" alt="Thread synchronization schema" width="1200">
</div>

### 4. [Code listing](./solution.adb)