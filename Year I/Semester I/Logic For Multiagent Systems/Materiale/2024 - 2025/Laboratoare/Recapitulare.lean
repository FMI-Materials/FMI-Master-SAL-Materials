-- Lab 1

-- inductive MyNat where
-- |    zero : MyNat
-- |    succ : MyNat -> MyNat

-- def one : MyNat := MyNat.succ MyNat.zero

open Nat

def isZero (n : Nat) : Bool :=
    match n with
    | zero => true
    | succ n' => false

-- strctural recursion
def factorial (n : Nat) : Nat :=
    match n with
    | zero => 1
    | succ n' => (succ n') * (factorial n')

-- nonstrctural recursion
-- def factorial (n : Nat) : Nat :=
--     match n with
--     | 0 => 1
--     | n' => n' * (factorial (n' - 1))

-- sumBetween n m = n + (n + 1) + (n + 2) + ... + (n + (m - 1))
def sumFrom (n m : Nat) : Nat :=
    match m with
    | zero      => 0
    | succ m'   => (n + m') + sumFrom n m'

-- mult n m = n * m (without using the built in *)
def mult (n m : Nat) : Nat :=
    match m with
    | zero      => zero
    | succ m'   => n + mult n m'

#eval mult 3 4

#eval factorial 5


-- 1 from lab1
-- 3 propositional lgic
-- 1 modal logic

-- Lab 2 PROPOSITIONAL LOGIC
-- , v, ->, <->, ~

variable (p q r : Prop)

#check And.intro

example : (p ∧ (q ∧ r)) → ((p ∧ q) ∧ r) := by
    intros h
    cases h with
    |   intro hp hqr =>
    cases hqr with
    |   intro hq hr =>
    apply And.intro
    . apply And.intro
      . assumption
      . assumption
    . assumption

example : (p → q ∧ r) → (p → q) ∧ (p → r) := by
    intros h
    apply And.intro
    . intros hp
      specialize h hp
      exact And.left h
    . intros hp
      have l : q ∧ r := h hp
      exact And.right l


#check Or.inl
#check Or.inr
example : (p ∨ (q ∨ r)) → ((p ∨ q) ∨ r) := by
    intros h
    cases h with
    |   inl hp =>
        apply Or.inl
        apply Or.inl
        assumption
    |   inr hqr =>
        cases hqr with
        |   inl hq =>
            exact Or.inl (Or.inr hq)
        |   inr hr =>
            exact Or.inr hr

example : (p → r) ∧ (q → r) → (p ∨ q → r) := by
    intros h
    intros h'
    cases h with
    | intro hpr hqr =>
    cases h' with
    | inl hp =>
      specialize hpr hp
      assumption
    | inr hq =>
      specialize hqr hq
      assumption
    done

example : (∀ p : Prop, p ⋁ ¬p) ↔ (∀ p : Prop, ¬¬p → p) := sorry

example : (p → ¬p → q) := by
    intros hp
    intros hnp
    contradiction

-- ¬p := p → False
example : (p → ¬p → q) := by
    intros hp
    intros hnp
    unfold Not at hnp
    specialize hnp hp
    -- exact False.elim
    exfalso
    assumption
end


macro "use" e:term : tactic => `(tactic| refine Exists.intro $e ?_)
section

   variable (p q : Nat → Prop)

   example : ∀ x, (p x → p x) := by
       intros n
       intros h
       assumption

    example : (∀ x, p x) → p 5 := by
       intros h
       specialize h 5
       assumption

    example : p 5 → ∃ x, p x := by
       intros h
       use 5
       assumption

    example : (∃ x, p x ∨ q x) → (∃ x, p x) ∨ (∃ x, q x) := by
       intros h
       cases h with
       | intro w hw =>
       cases hw with
       | inl hp =>
         apply Or.inl
         use w
         assumption
       | inr hq =>
         apply Or.inr
         use w
         assumption

end

section

    -- p → ¬p
    example : ¬(∀ p : Prop, p → ¬p) := by
        -- unfold Not
        intros h
        specialize h True
        have h' : True := by
            exact True.intro
        specialize h h'
        -- contradiction
        unfold Not at h
        exact h h'

    example : ¬(∀ p q : Prop, p ∨ q → q) := by
        intros h
        specialize h True False
        have h' : True ∨ False := by
            apply Or.inl
            exact True.intro
        specialize h h'
        assumption

end

section

    variable (p q : Prop)

    example : ¬(p ∧ q) → ¬p ∨ ¬q :=by
        intros h
        by_cases hp : p
        . apply Or.inr
          intros hq
          have hpq : p ∧ q := by
            exact And.intro hp hq
          contradiction
        . apply Or.inl
          assumption

    example : ¬(p ∧ q) → ¬p ∧ ¬q := by
        intros h
        by_cases hp : p
        . by_cases hq : q <;> (have h' : p ∨ q := Or.inl hp; contradiction)
        . by_cases hq : q
            . have h' : p ∨ q := Or.inr hq
                contradiction
            . exact And.intro hp hq

    example : ¬¬¬p → ¬p := by
        intros hnnnp
        intros hp
        have h' : p → ¬¬p := by
            intros hp
            intros hnp
            contradiction
        specialize h' hp
        contradiction

end


  example : ¬(∀ (p q : Nat → Prop), (∀ x, p x ∨ q x) → (∀ x, p x) ∨ (∀ x, q x)) := by
    intros h
    specialize h (fun x => x ≠ 0) (fun x => x = 0)
    have h1 : ∀ x, (fun x => x ≠ 0) x ∨ (fun x => x = 0) x := by
      intros x
      by_cases hx : x = 0
      . apply Or.inr
        exact hx
      . apply Or.inl
        exact hx
    have
    h2 : (∀ x, (fun x => x ≠ 0) x) ∨ (∀ x, (fun x => x = 0) x) := h h1
    cases h2 with
    | inl hp =>
      have hq : (fun x => x ≠ 0) 0 := hp 0
      contradiction
    | inr hp =>
      have hq : (fun x => x = 0) 1 := hp 1
      contradiction
