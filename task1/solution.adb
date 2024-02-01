
with Ada.Text_IO;
with Ada.Synchronous_Task_Control;
with Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control;
use Ada.Text_IO;
use Ada.Synchronous_Task_Control;
use Ada.Integer_Text_IO;
use Ada.Synchronous_Task_Control;

procedure lab_1 is
   N: constant Integer := 4;
   P: constant Integer := 2;
   H: constant Integer := N/P;
   tmp: constant Integer := 1;

   type Vector is array(1..N) of integer;
   type Matrix is array(1..N) of Vector;

   A, B, X: Vector;
   MO, MK, MT: Matrix;

   S0, S1, S2, S3, S4, S5, S6: Suspension_Object;

   function inputVector return Vector is
      V: Vector;
   begin
      for i in 1..N loop
         V(i) := tmp;
      end loop;
      return V;
   end inputVector;

   procedure outputVector (V: Vector) is
   begin
      for i in 1..N loop
         Put(V(i));
      end loop;
      Put_Line("");
   end outputVector;

   function inputMatrix return Matrix is
      M: Matrix;
   begin
      for i in 1..N loop
         for j in 1..N loop
            M(i)(j) := tmp;
         end loop;
      end loop;
      return M;
   end inputMatrix;

   procedure multiply_Vector_Matrix(V_res: out Vector; V: Vector; M: Matrix; thread_Id: Integer) is
      index_1: Integer := N/p * (thread_Id - 1) + 1;
      index_2: Integer := thread_Id * N/p;
   begin
      for i in index_1..index_2 loop
         V_res(i) := 0;
         for j in 1..N loop
            V_res(i) := V_res(i) + V(j) * M(i)(j);
         end loop;
      end loop;
   end multiply_Vector_Matrix;

   procedure multiply_Matrices(M_res: out Matrix; M1, M2: Matrix; thread_Id: Integer) is
      index_1: Integer := N/p * (thread_Id - 1) + 1;
      index_2: Integer := thread_Id * N/p;
   begin
      for i in index_1..index_2 loop
         for j in 1..N loop
            M_res(i)(j) := 0;
            for k in 1..N loop
               M_res(i)(j) := M_res(i)(j) + M1(i)(k) * M2(k)(j);
            end loop;
         end loop;
      end loop;
   end multiply_Matrices;


   procedure copyVector (V_out: out Vector; V_in: in Vector) is
   begin
      for i in 1..N loop
         V_out(i) := V_in(i);
      end loop;
   end copyVector;

   procedure copyMatrix (M_out : out Matrix; M_in : in Matrix) is
   begin
      for i in 1..N loop
         for j in 1..N loop
            M_out(i)(j) := M_in(i)(j);
         end loop;
      end loop;
   end copyMatrix;

   procedure startTasks is
      task T1;
      task T2;

      task body T1 is
         thread_Id : Integer := 1;
         B1, X1: Vector;
         MK1, M_tmp: Matrix;
      begin
         Put_Line("task T1 started");
         MK := inputMatrix;
         MT := inputMatrix;
         Set_True(S2);
         Suspend_Until_True(S3);

         Suspend_Until_True(S0);
         copyVector(B1, B);
         copyMatrix(MK1, MK);
         Set_True(S0);

         multiply_Vector_Matrix(X, B1, MO, thread_Id);
         Set_True(S4);
         Suspend_Until_True(S5);

         Suspend_Until_True(S1);
         copyVector(X1, X);
         Set_True(S1);

         multiply_Matrices(M_tmp, MK1, MT, thread_Id);
         multiply_Vector_Matrix(A, X1, M_tmp, thread_Id);
         Set_True(S6);

         Put_Line("task T1 finished");
      end T1;

      task body T2 is
         thread_Id : Integer := 2;
         B2, X2: Vector;
         MK2, M_tmp: Matrix;
      begin
         Put_Line("task T2 started");
         B := inputVector;
         MO := inputMatrix;
         Set_True(S3);
         Suspend_Until_True(S2);

         Suspend_Until_True(S0);
         copyVector(B2, B);
         copyMatrix(MK2, MK);
         Set_True(S0);

         multiply_Vector_Matrix(X, B2, MO, thread_Id);
         Set_True(S5);
         Suspend_Until_True(S4);
         --outputVector(X);

         Suspend_Until_True(S1);
         copyVector(X2, X);
         Set_True(S1);

         multiply_Matrices(M_tmp, MK2, MT, thread_Id);
         multiply_Vector_Matrix(A, X2, M_tmp, thread_Id);

         Suspend_Until_True(S6);
         if N < 8 then
            outputVector(A);
         end if;
         Put_Line("task T2 finished");
      end T2;

   begin
      null;
   end startTasks;

begin
   Put_Line("Main procedure sterted");
   Set_True(S0);
   Set_True(S1);
   startTasks;
   Put_Line("Main procedure finished");
end lab_1;
