
/-**Modal logic**-/

/-
  Modal logic is not a native part of Lean.
  As such, we will have to define it ourselves, beginning with the modal operators.
-/

opaque Box : Prop → Prop

prefix:max "□" => Box

/- **Exercise 1**: Give the standard definition of diamond in terms of box. -/
def Diamond (p : Prop) : Prop := sorry 

prefix:max "⋄" => Diamond

/-
  We define provability in the `K` logic, by adding all proof rules in an inductive type.
  You can ignore the details, just focus on the correspondence between these rules
  and their "pen and paper" formulation
-/
set_option hygiene false in prefix:100 "⊢K" => KProvable
inductive KProvable : Prop → Prop where
| tautology {p : Prop} : p → ⊢K p    -- this rule is oversimplified for the puprose of this lab; we will only used for propositional tautologies
| modusPonens {p q : Prop} : ⊢K p → ⊢K (p → q) → ⊢K q
| K {p q : Prop} : ⊢K (□(p → q) → □p → □q)
| necessitation {p : Prop} : ⊢K p → ⊢K □p

open KProvable

variable {p q : Prop}

/- The first proof is just a propositional theorem, which is "imported" in our system via `tautology` -/
example : ⊢K (□p ∨ ¬□p) := by
  have l₁ : □p ∨ ¬□p := Classical.em _
  exact tautology l₁

/- The same as before, plus an additional use of `necessitation` -/
example : ⊢K □(p → p) := by
  have l₁ : p → p := fun hp => hp
  have l₂ : ⊢K (p → p) := tautology l₁
  exact necessitation l₂

/- The translation of a standard proof you can find in the lecture notes -/
theorem ex1 : ⊢K (p → q) → ⊢K (□p → □q) := by
  intros h
  have l₁ : ⊢K □(p → q) := necessitation h
  have l₂ : ⊢K (□(p → q) → □p → □q) := K
  exact modusPonens l₁ l₂

/- You can use propositional proofs from previous labs, when needed -/

/- **Exercise 2** -/
theorem ex2 : ⊢K (□p → □¬¬p) := sorry 
/- **Exercise 3**-/
theorem ex3 : ⊢K (□p → □(q → p)) := sorry 

/- **Exercise 4** -/
theorem ex4 : ⊢K □p → ⊢K □(q → p) := sorry 

/- **Exercise 6** -/
theorem ex5 : ⊢K (□(p ∧ q) → □p ∧ □q) := sorry 


/- **Exercise 5** -/
example : ⊢K (p → q) → ⊢K (⋄p → ⋄q) := sorry 

/- **Exercise 7** -/
theorem ex7 : ⊢K (□p ∧ □q → □(p ∧ q)) := sorry 
