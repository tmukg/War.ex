defmodule War do
  @moduledoc """
    Documentation for `War`.
  """
  @doc """
  Kyle Galingan
  kgalingan@torontomu.ca
  501037503
  Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """
  #  Distributes cards into two even decks -> [] -> {[],[]}
  def distributeDeck(cards) do
    {a, b} = Enum.reduce(cards, {[],[]}, fn x, {a,b} ->
      if rem(Enum.count(a ++ b), 2) == 0 do
        {[x | a], b}
      else
        {a, [x | b]}
      end
    end)
    {Enum.reverse(a), Enum.reverse(b)}
  end

  # Method for sorting cards after War
  def sortCards(cards) do
    ones = Enum.filter(cards, fn x -> x == 1 end)
    other = Enum.reject(cards, fn x -> x == 1 end) |> Enum.sort(:desc)
    ones ++ other
  end

  # Return winning pile
  def gameplay([],p2), do: p2
  def gameplay(p1,[]), do: p1
  # Handles normal gameplay
  def gameplay(pOne, pTwo) do
    cond do
      Enum.at(pOne,0) == Enum.at(pTwo,0) ->
        gameplay(pOne,pTwo,2)
      Enum.at(pOne,0) < Enum.at(pTwo,0) ->
        gameplay(tl(pOne), tl(pTwo) ++ [Enum.at(pTwo,0)] ++ [Enum.at(pOne,0)])
      Enum.at(pOne,0) > Enum.at(pTwo,0) ->
        gameplay(tl(pOne)++[Enum.at(pOne,0)]++[Enum.at(pTwo,0)], tl(pTwo))
    end
  end
  # Handles war gameplay
  def gameplay(p1,p2,index) do
    cond do
      #Loop war
      (Enum.at(p1, index) == Enum.at(p2, index)) ->
        gameplay(Enum.slice(p1, index+1..-1), Enum.slice(p2, index+1..-1), 1, sortCards(Enum.slice(p1,0..index) ++ Enum.slice(p2,0..index)))
      #Return to regular play - Player One wins
      ((Enum.at(p1, index) > Enum.at(p2, index) or (Enum.at(p1, index) == 1)) and (Enum.at(p2, index) != 1)) ->
        gameplay(Enum.slice(p1, index+1..-1) ++ sortCards(Enum.slice(p1,0..index) ++ Enum.slice(p2,0..index)),Enum.slice(p2,index+1..-1))
      #Return to regular play - Player Two wins
      ((Enum.at(p1, index) < Enum.at(p2, index) or (Enum.at(p2, index) == 1)) and (Enum.at(p1, index) != 1)) ->
        gameplay(Enum.slice(p1, index+1..-1),Enum.slice(p2,index+1..-1)  ++ sortCards(Enum.slice(p1,0..index) ++ Enum.slice(p2,0..index)))

    end
  end
  #War when one player has no cards left or one card left - return War pile
  def gameplay([],[],index,pile), do: pile
  def gameplay([lastOne],[lastTwo],index,pile) do
    sortCards(pile++[lastOne]++[lastTwo])
  end

  def gameplay(p1,p2,index,pile) do
    cond do
      #Loop war
      Enum.at(p1, index) == Enum.at(p2, index) ->
        gameplay(Enum.slice(p1, index+1..-1), Enum.slice(p2, index+1..-1), 1, sortCards(pile++Enum.slice(p1,0..index)++Enum.slice(p2,0..index)))
      #Return to regular play - Player One wins
      Enum.at(p1, index) > Enum.at(p2, index) && Enum.at(p2, index) != 1 ->
        gameplay(Enum.slice(p1,index+1..-1)++sortCards(pile++Enum.slice(p1,0..index)++Enum.slice(p2,0..index)),Enum.slice(p2,index+1..-1))
      #Return to regular play - Player Two wins
      Enum.at(p1, index) < Enum.at(p2, index) && Enum.at(p1, index) != 1 ->
        gameplay(Enum.slice(p1,index+1..-1),Enum.slice(p2,index+1..-1)++sortCards(pile++Enum.slice(p1,0..index)++Enum.slice(p2,0..index)))
    end
  end

  #Splits list into two piles.
  def deal({[],p2}), do: p2
  def deal({p1,[]}), do: p1
  def deal(shuf) do
    cards= War.distributeDeck(shuf)
    pOne = Enum.reverse(elem(cards,0))
    pTwo = Enum.reverse(elem(cards,1))
    gameplay(pOne,pTwo)
  end
end

