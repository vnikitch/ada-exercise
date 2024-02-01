with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure solution is
   N: constant Integer := 4;
   P: constant Integer := 8;
   H: constant Integer := N/P;
   tmp: constant Integer := 1;
   type Vector is array(Integer range <>) of integer;
   type Matrix is array(Integer range <>) of Vector(1..N);

   function inputMatrix return Matrix is
      M: Matrix(1..N);
   begin
      for i in 1..N loop
         for j in 1..N loop
            M(i)(j) := 1;
         end loop;
      end loop;
      return M;
   end inputMatrix;

   procedure outputMatrix (M: Matrix) is
   begin
      for i in M'Range loop
         for j in 1..N loop
            Put(M(i)(j));
         end loop;
         New_Line;
      end loop;
      New_Line;
   end outputMatrix;

   function multiplyMatrices(M1, M2: Matrix) return Matrix is
      M_res: Matrix(M1'Range);
   begin
      for i in M1'Range loop
         for j in 1..N loop
            M_res(i)(j) := 0;
            for k in 1..N loop
               M_res(i)(j) := M_res(i)(j) + M1(i)(k) * M2(k)(j);
            end loop;
         end loop;
      end loop;
      return M_res;
   end multiplyMatrices;

   function multiplyDigitMatrix(a: Integer; M: Matrix) return Matrix is
      M_res: Matrix(1..M'Length);
   begin
      for i in M'Range loop
         for j in 1..N loop
            M_res(i)(j) := M(i)(j) * a;
         end loop;
      end loop;
      return M_res;
   end multiplyDigitMatrix;

   function sumMatrices(M1, M2: Matrix) return Matrix is
      M_res: Matrix(1..M1'Length);
   begin
      for i in M1'Range loop
         for j in 1..N loop
            M_res(i)(j) := M1(i)(j) + M2(i)(j);
         end loop;
      end loop;
      return M_res;
   end sumMatrices;

   function concatMatrices(M1, M2: Matrix) return Matrix is
      M_res: Matrix(1..M1'Length + M2'Length);
      j: Integer := 1;
   begin
      for i in M1'Range loop
         M_res(i) := M1(i);
      end loop;
      for i in M1'Length+1..M_res'Length loop
         M_res(i) := M2(j);
         j := j + 1;
      end loop;
      return M_res;
   end concatMatrices;

   function getPartOfMatrix(M: Matrix; index1, index2: Integer) return Matrix is
      M_res: Matrix(index1..index2);
   begin
      for i in index1..index2 loop
         M_res(i) := M(i);
      end loop;
      return M_res;
   end getPartOfMatrix;
   ---------------------------------------------------------------------
   task T1 is
      entry setMB_D(MBh: Matrix; dd: Integer);
      entry setMC(MCh: Matrix);
      entry setMK(MKh: Matrix);
   end T1;

   task T2 is
      entry setMB_D(MBh: Matrix; dd: Integer);
      entry setMC(MCh: Matrix);
      entry setMK(MKh: Matrix);
      entry resultT3(MAh: Matrix);
      entry resultT1(MAh: Matrix);
      entry resultT5(MAh: Matrix);
   end T2;

   task T3 is
      entry setMB_D(MBh: Matrix; dd: Integer);
      entry setMK(MKh: Matrix);
      entry setMC(MCh: Matrix);
      entry resultT7(MAh: Matrix);
      entry resultT6(MAh: Matrix);
   end T3;

   task T4 is
      entry setMB_D(MBh: Matrix; dd: Integer);
      entry setMC(MCh: Matrix);
      entry result(MAh: Matrix);
   end T4;

   task T5 is
      entry setMB_D(MBh: Matrix; dd: Integer);
      entry setMC(MCh: Matrix);
      entry setMK(MKh: Matrix);
   end T5;

   task T6 is
      entry setMB_D(MBh: Matrix; dd: Integer);
      entry setMK(MKh: Matrix);
   end T6;

   task T7 is
      entry setMB_D(MBh: Matrix; dd: Integer);
      entry setMK(MKh: Matrix);
      entry setMC(MCh: Matrix);
      entry resultT8(MAh: Matrix);
   end T7;

   task T8 is
      entry setMC(MCh: Matrix);
      entry setMK(MKh: Matrix);
   end T8;
   ---------------------------------------------------------------------------
   task body T1 is
      threadId: Integer := 0;
      MA, MB, MC: Matrix(1..H);
      MK: Matrix(1..N);
      d: Integer;
   begin
      Put_Line("Task 1 started");
      accept setMB_D (MBh : in Matrix; dd : in Integer) do
         MB := MBh;
         d := dd;
      end setMB_D;

      accept setMC (MCh : in Matrix) do
         MC := MCh;
      end setMC;

      accept setMK (MKh : in Matrix) do
         MK := MKh;
      end setMK;

      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));
      T2.resultT1(MA);
      Put_Line("Task 1 finished");
   end T1;

   task body T2 is
      threadId: Integer := 1;
      result_T1, result_T5, MA, MB, MC: Matrix(1..H);
      result_T3: Matrix(1..N-4*H);
      result_T35, result_T12: Matrix(1..2*H);
      result_T3_new: Matrix(1..N-3*H);
      result_T678: Matrix(1..N-5*H);
      MK: Matrix(1..N);
      d: Integer;
      MB4h, MC4h: Matrix(1..4*H);
   begin
      Put_Line("Task 2 started");
      accept setMB_D (MBh : in Matrix; dd : in Integer) do
         MB4h := MBh;
         MB := getPartOfMatrix(MBh, H*threadId + 1, H*(threadId + 1));
         d := dd;
      end setMB_D;

      accept setMC (MCh : in Matrix) do
         MC4h := MCh;
         MC := getPartOfMatrix(MCh, H*threadId + 1, H*(threadId + 1));
      end setMC;

      T1.setMB_D(getPartOfMatrix(MB4h, 1, H), d);
      T1.setMC(getPartOfMatrix(MC4h, 1, H));
      T4.setMB_D(getPartOfMatrix(MB4h, 2*H+1, 3*H), d);
      T4.setMC(getPartOfMatrix(MC4h, 2*H+1, 3*H));
      T5.setMB_D(getPartOfMatrix(MB4h, 3*H+1, 4*H), d);
      T5.setMC(getPartOfMatrix(MC4h, 3*H+1, 4*H));

      accept setMK (MKh : in Matrix) do
         MK := MKh;
      end setMK;
      T1.setMK(MK);
      T5.setMK(MK);
      T3.setMK(MK);
      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));

      for i in 1..3 loop
         select
            accept resultT3 (MAh : in Matrix) do
               result_T3 := MAh;
            end resultT3;
         or
            accept resultT1 (MAh : in Matrix) do
               result_T1 := MAh;
            end resultT1;
         or
            accept resultT5 (MAh : in Matrix) do
               result_T5 := MAh;
            end resultT5;
         end select;
		 
      end loop;

      result_T12 := concatMatrices(result_T1, MA); -- T1 + T2
      result_T35 := concatMatrices(getPartOfMatrix(result_T3, 1, H), result_T5); --T3 + T5
      result_T678 := getPartOfMatrix(result_T3, H+1, N-4*H); --T6 + T7 + T8
      result_T3_new := concatMatrices(result_T35, result_T678);
      T4.result(concatMatrices(result_T12, result_T3_new));
      Put_Line("Task 2 finished");
   end T2;

   task body T3 is
      threadId: Integer := 2;
      result_T6, MA, MB, MC: Matrix(1..H);
      result_T7: Matrix(1..N-6*H);
      MB6h: Matrix(1..6*H);
      MC7h: Matrix(1..N-H);
      MK: Matrix(1..N);
      d: Integer;
      m1, m2: Matrix(1..2*H);
   begin
      Put_Line("Task 3 started");
      for i in 1..2 loop
         select
            accept setMB_D (MBh : in Matrix; dd : in Integer) do
               d := dd;
               MB := getPartOfMatrix(MBh, H*threadId + 1, H*(threadId + 1));
               MB6h := MBh;
            end setMB_D;
         or
            accept setMC(MCh: Matrix) do
               MC7h := MCh;
               MC := getPartOfMatrix(MCh, H*threadId + 1, H*(threadId + 1));
            end setMC;
         end select;
      end loop;

      T6.setMB_D(getPartOfMatrix(MB6h, H*5 + 1, H*6), d);
      m1 := getPartOfMatrix(MB6h, 1, H*threadId);
      m2 := getPartOfMatrix(MB6h, H*3 + 1, H*5);
      T2.setMB_D(concatMatrices(m1, m2), d);
      m1 := getPartOfMatrix(MC7h, 1, H*threadId);
      m2 := getPartOfMatrix(MC7h, H*3 + 1, H*5);
      T2.setMC(concatMatrices(m1, m2));
      T7.setMC(getPartOfMatrix(MC7h, 5*H+1, N-H));
      accept setMK (MKh : in Matrix) do
         MK := MKh;
      end setMK;
      T6.setMK(MK);
      T7.setMK(MK);
      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));

      for i in 1..2 loop
         select
            accept resultT7 (MAh : in Matrix) do
               result_T7 := MAh;
            end resultT7;
         or
            accept resultT6 (MAh : in Matrix) do
               result_T6 := MAh;
            end resultT6;
         end select;
      end loop;
      T2.resultT3(concatMatrices(MA, concatMatrices(result_T6, result_T7)));
      Put_Line("Task 3 finished");
   end T3;

   task body T4 is
      threadId: Integer := 3;
      MA, MB, MC: Matrix(1..H);
      MA3h: Matrix(1..3*H);
      MA4h: Matrix(1..N-4*H);
      MK, MA_result: Matrix(1..N);
      d: Integer;
   begin
      Put_Line("Task 4 started");
      MK := inputMatrix;
      accept setMB_D (MBh : in Matrix; dd : in Integer) do
         MB := MBh;
         d := dd;
      end setMB_D;

      accept setMC (MCh : in Matrix) do
         MC := MCh;
      end setMC;
      T2.setMK(MK);

      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));
      accept result (MAh : in Matrix) do
         MA3h := getPartOfMatrix(MAh, 1, 3*H);
         MA4h := getPartOfMatrix(MAh, 3*H+1, N-H);
         MA_result := concatMatrices(concatMatrices(MA3h, MA), MA4h);
         outputMatrix(MA_result);
      end result;

      Put_Line("Task 4 finished");
   end T4;

   task body T5 is
      threadId: Integer := 4;
      MA, MB, MC: Matrix(1..H);
      MK: Matrix(1..N);
      d: Integer;
   begin
      Put_Line("Task 5 started");
      accept setMB_D (MBh : in Matrix; dd : in Integer) do
         MB := MBh;
         d := dd;
      end setMB_D;

      accept setMC (MCh : in Matrix) do
         MC := MCh;
      end setMC;

      accept setMK (MKh : in Matrix) do
         MK := MKh;
      end setMK;

      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));
      T2.resultT5(MA);
      Put_Line("Task 5 finished");
   end T5;

   task body T6 is
      threadId: Integer := 5;
      MA, MB, MC: Matrix(1..H);
      MC_full, MK: Matrix(1..N);
      d: Integer;
      m1: Matrix(1..H*threadId);
      m2: Matrix(1..N - (H*(threadId + 1)));
   begin
      Put_Line("Task 6 started");
      MC_full := inputMatrix;
      m1 := getPartOfMatrix(MC_full, 1, H*threadId);
      m2 := getPartOfMatrix(MC_full, H*(threadId + 1) + 1, N);
      T3.setMC(concatMatrices(m1, m2));
      MC := getPartOfMatrix(MC_full, H*threadId + 1, H*(threadId + 1));
      accept setMB_D(MBh: Matrix; dd: Integer) do
         MB := MBh;
         d := dd;
      end setMB_D;

      accept setMK (MKh : in Matrix) do
         MK := MKh;
      end setMK;

      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));
      T3.resultT6(MA);
      Put_Line("Task 6 finished");
   end T6;

   task body T7 is
      threadId: Integer := 6;
      MA, MB, MC: Matrix(1..H);
      MB7h: Matrix(1..7*H);
      MK: Matrix(1..N);
      d: Integer;
      MC2h, MA2h: Matrix(1..N-H*6);
   begin
      Put_Line("Task 7 started");
      accept setMB_D (MBh : in Matrix; dd : in Integer) do
         d := dd;
         MB := getPartOfMatrix(MBh, H*threadId + 1, H*(threadId + 1));
         MB7h := MBh;
      end setMB_D;
      T3.setMB_D(getPartOfMatrix(MB7h, 1, H*threadId), d);

      accept setMC(MCh: Matrix) do
         MC2h := MCh;
         MC := getPartOfMatrix(MC2h, 1, H);
      end setMC;
      T8.setMC(getPartOfMatrix(MC2h, H+1, N-6*H));

      accept setMK(MKh: Matrix) do
         MK := MKh;
      end setMK;
      T8.setMK(MK);

      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));
      accept resultT8 (MAh : in Matrix) do
         MA2h := concatMatrices(MA, MAh);
      end resultT8;
      T3.resultT7(MA2h);
      Put_Line("Task 7 finished");
   end T7;

   task body T8 is
      threadId: Integer := 7;
      MA, MC, MB: Matrix(1..N - 7*H);
      MB_full, MK: Matrix(1..N);
      d: Integer;
   begin
      Put_Line("Task 8 started");
      d := tmp;
      MB_full := inputMatrix;
      MB := getPartOfMatrix(MB_full, H*threadId + 1, N);
      T7.setMB_D(getPartOfMatrix(MB_full, 1, H*threadId), d);

      accept setMC(MCh: Matrix) do
         MC := MCh;
      end setMC;

      accept setMK(MKh: Matrix) do
         MK := MKh;
      end setMK;

      MA := sumMatrices(multiplyDigitMatrix(d, MB), multiplyMatrices(MC, MK));
      T7.resultT8(MA);
      Put_Line("Task 8 finished");
   end T8;
begin
   null;
end solution;
