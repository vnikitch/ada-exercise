# Task 1

1. Given the PC/RAM architecture: <div style="margin: 10px; text-align: center;">
   <img src="architecture.svg" alt="architecture" width="400"></div>
2. Task to calculate: A = (B * MO) * (MK * MT)
   - A, B: Vector (e.g., 1d array)
   - MO, MK, MT: Matrix (e.g., 2d array)
   - A<sub>h</sub> : represents a sub-vector of A
3. Programming language: Ada
   - Thread communication means: semaphores
4. Abbreviation used:
   - Tx --> thread with the index `x`
   - CS --> critical section
   - S<sub>x;y</sub> --> `signal` (e.g., notify) thread Tx from the current thread, where `y` specifies the index of this signal in the current thread.
     - For example, S<sub>2;1</sub> specifies a `signal` to thread T2 from current thread. This signal is the first one in the current thread
     - The next signal from the current thread to thread T4 should be specified as S<sub>4;2</sub>
     - Each thread maintains its own index for its signals
   - W<sub>x;y</sub> --> `wait` for a signal from Tx where `y` specifies the index of this wait operation in the current thread. The thread suspends while waiting.
     - For example, W<sub>3;1</sub> specifies a first `wait` for a signal from T3
     - The next `wait` from, for instance T2 should be specified as W<sub>2;2</sub> in the same thread.
     - Each thread maintains its own index for its waits

---

# Solution

### 1. Parallel mathematical algorithm:

1. X<sub>h</sub> = B * MO
2. A<sub>h</sub> = X * ( MK * MT<sub>h</sub> )
   - shared resource: B, X, MK

### 2. Developing the algorithm for each thread

|                 | T1                                                                                      | T2                                                                                   |                 |
|:---------------:|-----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|:---------------:|
|                 | 1. Input `MK`, `MT`                                                                     | 1. Input `В`, `МО`                                                                   |                 |
| S<sub>2;1</sub> | 2. Signal thread T2 about `МК` and `МТ` input completion                                | 2. Signal T1 about `В` and `МО` input completion                                     | S<sub>1;1</sub> |
| W<sub>2;1</sub> | 3. Wait for a signal from T2 indicating the input completion of `В` and `МО`            | 3. Wait for a signal from T1 indicating the input completion of `MK` and `МT`        | W<sub>1;1</sub> |
|       CS        | 4. Copy (into local thread memory):<br/> • В<sub>1</sub> = В<br/> • МК<sub>1</sub> = МК | 4. Copy:<br/> • В<sub>2</sub> = В<br/> • МК<sub>2</sub> = МК                         |       CS        |
|                 | 5. Calculate: X<sub>h</sub> = В<sub>1</sub> * MO                                        | 5. Calculate: X<sub>h</sub> = В<sub>2</sub> * MO                                     |                 |
| S<sub>2;2</sub> | 6. Signal T2 about calculation completion of X<sub>h</sub>                              | 6. Signal T1 about calculation completion of X<sub>h</sub>                           | S<sub>1;2</sub> |
| W<sub>2;2</sub> | 7. Wait for a signal from T2 indicating the calculation completion of X<sub>h</sub>     | 7. Wait for a signal from T1 indicating the calculation completion of X<sub>h</sub>  | W<sub>1;2</sub> |
|       CS        | 8. Copy: X<sub>1</sub> = X                                                              | 8. Copy: X<sub>2</sub> = X                                                           |       CS        |
|                 | 9. Calculate: A<sub>h</sub> = X<sub>1</sub> * ( MK<sub>1</sub> * MT<sub>h</sub> )       | 9. Calculate: A<sub>h</sub> = X<sub>2</sub> * ( MK<sub>2</sub> * MT<sub>h</sub> )    |                 |
| S<sub>2;3</sub> | 10. Signal T2 about calculation completion A<sub>h</sub>                                | 10. Wait for a signal from T1 indicating the calculation completion of A<sub>h</sub> | W<sub>1;3</sub> |
|                 |                                                                                         | 11. Output `A`                                                                       |                 |

### 3. Schema of the thread interaction:

<div style="margin: 0; text-align: center;">
   <img src="synchronization.svg" alt="Thread synchronization schema" width="900">
</div>

### 4. [Code listing](./solution.adb)