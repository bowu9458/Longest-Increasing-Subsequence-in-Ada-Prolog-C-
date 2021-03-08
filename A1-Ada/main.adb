with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;


with Ada.Containers; use Ada.Containers;
with Ada.Containers.Vectors;


procedure Main is

  -- 1D array 
  package Integer_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Integer);
  use Integer_Vectors;

  -- 2D array
  package TwoDimenional_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Vector);

  Origional_vector : Integer_Vectors.Vector;
  Result: TwoDimenional_Vectors.Vector;


  Input_list : String (1 .. 1000);

  -- used for processing string
  Last: Natural;
  Number_start: Integer;
  Start_bool : BOOLEAN := False;


-- nested function
  function lis(previous: Integer; current: Integer; origional_list: Vector) return TwoDimenional_Vectors.Vector is 
    TwoD_vector_empty: TwoDimenional_Vectors.Vector;
    TwoD_vector_skip: TwoDimenional_Vectors.Vector;
    TwoD_vector_take: TwoDimenional_Vectors.Vector;
    Length_skip: Integer;
    Length_take: Integer;
    OneD_vector: Vector;

    -- nested function combine two dimentional vector
    function append_without_dup (first_vectors: TwoDimenional_Vectors.Vector; second_vectors: TwoDimenional_Vectors.Vector; length: Integer) return TwoDimenional_Vectors.Vector is

      TwoD_vector_combined: TwoDimenional_Vectors.Vector;

      Duplicated : BOOLEAN := False;
      index_twoD : Integer := 0;

      Number_vectors : Integer;

    begin
      Number_vectors := Integer(first_vectors.Length);
      for v of second_vectors loop

        while Duplicated = False and index_twoD < Number_vectors loop
          if v = first_vectors(index_twoD) then
            Duplicated := True;
          end if;
          index_twoD := index_twoD + 1;
        end loop;

        if Duplicated = False then
          TwoD_vector_combined.append(v);
        end if;

        index_twoD := 0;
        Duplicated := False;
      end loop;

      for v of first_vectors loop
        TwoD_vector_combined.append(v);
      end loop;

      return TwoD_vector_combined;
    end append_without_dup;

  begin
  	-- base case
    if current > Integer(origional_list.Length-1) then
      return TwoD_vector_empty;

    -- have to skip current element
    elsif origional_list(previous) >= origional_list(current) then
      return lis(previous, current+1 , origional_list);

    -- skip or take current element
    else
      -- check which one, skip or take or both, has longer increasing subsequence

      -- get skip
      TwoD_vector_skip := lis(previous, current+1, origional_list);

      if not TwoD_vector_skip.Is_Empty then  
        Length_skip :=  Integer(TwoD_vector_skip(0).Length);
      else
        Length_skip := 0;
      end if;


      -- get take
      TwoD_vector_take := lis(current, current+1, origional_list);
      if not TwoD_vector_take.Is_Empty then  
        Length_take := Integer(TwoD_vector_take(0).Length) + 1;
        for V of TwoD_vector_take loop
            V.prepend(origional_list(current));
        end loop;
      else
        Length_take := 1;
        OneD_vector.append(origional_list(current));
        TwoD_vector_take.append(OneD_vector);
      end if;

      
      -- compare take and skip
      if Length_take < Length_skip then
        return TwoD_vector_skip;

      elsif Length_take = Length_skip then
        -- combine TwoD_vector_skip and take
        TwoD_vector_take := append_without_dup(TwoD_vector_take,TwoD_vector_skip, Length_take);
        return  TwoD_vector_take;

      else
        return TwoD_vector_take;
      end if;


    end if;

  end lis;
-- end of nested function


begin
  -- read origional list from keyboard
  Get_Line(Input_list, Last);

  -- convert string of numbers into integer in 
  for i in 1..Last loop
    if Input_list(i..i) /= " " and  Start_bool = False then
      Number_start := i;
      Start_bool := True;

      if  i = Last then
        Origional_vector.append(Integer'Value (Input_list(i..i)));
      end if;

    elsif  i = Last and Start_bool = True then
        Origional_vector.append(Integer'Value (Input_list(Number_start..i)));  

    elsif Input_list(i..i) = " " and Start_bool = True then
      Origional_vector.append(Integer'Value (Input_list(Number_start..i-1)));
      Start_bool := False;
    end if;
  end loop;


  --used for entering the recursion
  Origional_vector.prepend(-1000000000);  


  Result := lis(0, 1, Origional_vector);

  -- print result
  for V of Result loop
    for N of V loop
      Put(Integer'Image (N));
      Put(" ");
    end loop;
    Put_line("");
  end loop;

end Main;