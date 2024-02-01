with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure solution is
   N: constant Integer := 4;
   P: constant Integer := 4;
   H: constant Integer := N/P;
   tmp: constant Integer := 1;
   type Vector is array(1..N) of integer;
   type Matrix is array(1..N) of Vector;

   A, Z, E, V_tmp1, V_tmp2, V_tmp3, V_tmp4: Vector;
   MO, M_tmp1: Matrix;

   task type MyTask (threadId : Integer);
   type myTask_ptr is access MyTask;
   task_ptr: myTask_ptr;

   protected type DataMonitorType is
      procedure set_m_min(m: Integer);
      procedure set_m_max(m: Integer);
      procedure set_d(value: Integer);
      procedure set_T(value: Vector);
      procedure set_MK(value: Matrix);
      function get_m_min return Integer;
      function get_m_max return Integer;
      function get_d return Integer;
      function get_T return Vector;
      function get_MK return Matrix;
   private
      m_min: Integer := 9999;
      m_max: Integer := -9999;
      d: Integer;
      T: Vector;
      MK: Matrix;
   end DataMonitorType;

   protected body DataMonitorType is
      procedure set_m_min(m: Integer) is
      begin
         m_min := Integer'Min(m_min, m);
      end set_m_min;

      procedure set_m_max(m: Integer) is
      begin
         m_max := Integer'Max(m_max, m);
      end set_m_max;

      procedure set_d(value: Integer) is
      begin
         d := value;
      end set_d;

      procedure set_T(value: Vector) is
      begin
         T := value;
      end set_T;

      procedure set_MK(value: Matrix) is
      begin
         MK := value;
      end set_MK;

      function get_m_min return Integer is
      begin
         return m_min;
      end get_m_min;

      function get_m_max return Integer is
      begin
         return m_max;
      end get_m_max;

      function get_d return Integer is
      begin
         return d;
      end get_d;

      function get_T return Vector is
      begin
         return T;
      end get_T;

      function get_MK return Matrix is
      begin
         return MK;
      end get_MK;
   end DataMonitorType;

   protected type SyncMonitorType is
        entry waitForInput;
        procedure finishInput;

        entry waitCount_m;
        procedure finishCount_m;

        entry waitCount_A;
        procedure finishCount_A;
    private
        inputs: Integer := 0;
        count_m: Integer := 0;
        countA: Integer := 0;
    end SyncMonitorType;

   protected body SyncMonitorType is
      entry waitForInput when inputs = 3 is
      begin
         null;
      end waitForInput;

      procedure finishInput is
      begin
         inputs := inputs + 1;
      end finishInput;

      entry waitCount_m when count_m = P is
      begin
         null;
      end waitCount_m;

      procedure finishCount_m is
      begin
         count_m := count_m + 1;
      end finishCount_m;

      entry waitCount_A when countA = P is
      begin
         null;
      end waitCount_A;

      procedure finishCount_A is
      begin
         countA := countA + 1;
      end finishCount_A;
   end SyncMonitorType;


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

   procedure multiply_Matrices(M_res: out Matrix; M1, M2: Matrix; index_1, index_2: Integer) is
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

   procedure multiply_Vector_Matrix(V_res: out Vector; V: Vector; M: Matrix; index_1, index_2: Integer) is
   begin
      for i in index_1..index_2 loop
         V_res(i) := 0;
         for j in 1..N loop
            V_res(i) := V_res(i) + V(j) * M(i)(j);
         end loop;
      end loop;
   end multiply_Vector_Matrix;

   procedure multiply_Int_Vector(V_res: out Vector; a: Integer; V: Vector; index_1, index_2: Integer) is
   begin
      for i in index_1..index_2 loop
         V_res(i) := V(i) * a;
      end loop;
   end multiply_Int_Vector;

   function getMinVectorInt(V: Vector; index_1, index_2: Integer) return Integer is
      res: Integer := V(index_1);
   begin
      for i in index_1..index_2 loop
         if V(i) < res then
            res := V(i);
         end if;
      end loop;
      return res;
   end getMinVectorInt;

   function getMaxVectorInt(V: Vector; index_1, index_2: Integer) return Integer is
      res: Integer := V(index_1);
   begin
      for i in index_1..index_2 loop
         if V(i) > res then
            res := V(i);
         end if;
      end loop;
      return res;
   end getMaxVectorInt;

   procedure sumVector(V_res: out Vector; V1, V2: Vector; index_1, index_2: Integer) is
   begin
      for i in index_1..index_2 loop
         V_res(i) := V1(i) + V2(i);
      end loop;
   end sumVector;


   syncMonitor: SyncMonitorType;
   dataMonitor: DataMonitorType;

   task body MyTask is
      index_1, index_2: Integer;
   begin
      index_1 := H * threadId + 1;
      if threadId = P - 1
      then index_2 := N;
      else index_2 := (threadId + 1) * H;
         end if;

      Put("task "); Put(threadId); Put(" started"); New_Line;
      if threadId = 0 then
         Z := inputVector;
         E := inputVector;
      end if;
      if threadId = 1 then
         dataMonitor.set_d(tmp);
         MO := inputMatrix;
      end if;
      if threadId = 3 then
         dataMonitor.set_T(inputVector);
         dataMonitor.set_MK(inputMatrix);
      end if;

      if threadId /= 2 then
         syncMonitor.finishInput;
      end if;
      syncMonitor.waitForInput;

      dataMonitor.set_m_min(getMinVectorInt(Z, index_1, index_2));
      dataMonitor.set_m_max(getMaxVectorInt(Z, index_1, index_2));
      syncMonitor.finishCount_m;
      syncMonitor.waitCount_m;

      multiply_Matrices(M_tmp1, MO, dataMonitor.get_MK, index_1, index_2);
      multiply_Vector_Matrix(V_tmp1, dataMonitor.get_T, M_tmp1, index_1, index_2);
      multiply_Int_Vector(V_tmp2, dataMonitor.get_m_min, V_tmp1, index_1, index_2);
      multiply_Int_Vector(V_tmp3, dataMonitor.get_d, V_tmp2, index_1, index_2);
      multiply_Int_Vector(V_tmp4, dataMonitor.get_m_max, E, index_1, index_2);
      sumVector(A, V_tmp2, V_tmp4, index_1, index_2);

      syncMonitor.finishCount_A;
      if threadId = 0 then
         syncMonitor.waitCount_A;
         outputVector(A);
      end if;
     --Put("task "); Put(threadId); Put(" finished"); New_Line;
   end MyTask;

begin
   Put_Line("Main procedure started");
   task_ptr := new MyTask(0);
   task_ptr := new MyTask(1);
   task_ptr := new MyTask(2);
   task_ptr := new MyTask(3);
end solution;