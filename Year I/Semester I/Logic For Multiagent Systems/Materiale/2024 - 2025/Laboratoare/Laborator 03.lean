-- Ignore the following two lines
set_option autoImplicit false

macro "use" e:term : tactic => `(tactic| refine Exists.intro $e ?_)

/- *** First-order logic -/

/-
  Beyond the propositional connectives we have seen in Lab2,
  we are also provided with the first-order quantifiers, ∀ and ∃,
  enabling us to state and prove properties of objects.
-/

/- ** Universal quantifier -/
/-
  Given a type `α : Type` and a function `p : α → Prop`
  (i.e. a unary predicate on `α`), we can form the new proposition
  `∀ x : α, p a`, stating that `p` holds for all `x` in `α`.
-/
variable {α : Type} (p : α → Prop)
#check ∀ x : α, p x

/- One may omit type annotations when they are inferrable from context -/
#check ∀ x, p x

/-
  In order to prove a universal statement `∀ x : α, p x`,
  the basic strategy is to assume an aribtrary `x : α`,
  and then prove `p x` for it.
  This can be done using the `intros` tactic, just like assume the hypothesis of an implication.
-/

example : ∀ n : Nat, 0 ≤ n := by
  intros n
  exact Nat.zero_le n -- a lemma from the standard library

#check Nat.zero_add
/- Exercise 1. Hint: Use the lemma above -/
example : ∀ n : Nat, 0 + n = n := sorry 

#check Nat.add_comm
/- Exercise 2. Hint: Use the lemma above -/
example : ∀ (n : Nat) (m : Nat), n + m = m + n := sorry 

/- Exercise 3 -/
example : ∀ x : α, p x → p x := sorry 
/-
  If you have a universal hypothesis `h : ∀ x : α, p x`,
  this can be instantiated to any expression `a : α`, producing
  a proof of `p a`.

  This instantiation can be done simply by function application
-/
variable (a : α)
#check p a

example : (∀ x : α, p x) → p a := by
  intros h
  exact h a
/- Or as a function -/
example : (∀ x : α, p x) → p a := fun h => h a

/- Alternatively, the `specialize` tactic can be used to replace a universal hypothesis
  with an instantiation thereof.
-/
example : (∀ x : α, p x) → p a := by
  intros h
  specialize h a
  assumption

variable (q : α → Prop)

example : (∀ x : α, p x) ∧ (∀ x, q x) → (∀ x : α, p x ∧ q x) := by
  intros h
  intros a
  cases h with
  | intro hp hq =>
  specialize hp a
  specialize hq a
  exact And.intro hp hq

/- Exercise 4 -/
example : (∀ x : α, p x ∧ q x) → (∀ x : α, p x) ∧ (∀ x, q x) := sorry 

/- Exercise 5 -/
example : (∀ x, p x → q x) → (∀ x, p x) → (∀ x, q x) := sorry 


/- ** Existential quantifier -/

/-
  Given a type `α` and a predicate on `p : α → Prop` on `α`,
  we can construct the proposition `∃ x : α, p x`,
  stating that there exists an `x` in `α` such that `p x` holds.
-/
#check ∃ x : α, p x
#print Exists

/- Proving an existential statement `∃ x : α, p x`
  involves providing a `w : α` (called a witness) and proving that `p` holds for `w`.

  You can do this with the `use` tactic, which accepts a term (claimed to be a witness)
  and then asks you to prove that it is indeed a witness.
-/
#check @Exists.intro

example (m : Nat) : ∃ n : Nat, m + n = m := by
  use 0
  exact Nat.add_zero m -- a lemma from the standard library


variable (p q : Nat → Prop)

/- Exercise 6 -/
example : (∀ x : Nat, p x) → (∃ x : Nat, p x) := sorry 

/- Exercise 7 -/
example : (∀ x : Nat, p x) → (∃ x : Nat, p x) ∨ (∃ x : Nat, q x) := sorry 
/- Exercise 8 -/

example : ∀ x : Nat, ∃ y : Nat, x = y := sorry 

/-
  If you have an existential hypothesis `h : ∃ x : α, p x`,
  you can use `cases h with | intro w hw` to split `h` into a witness `w` and a proof `hw` that `w`
  satisfies `p`.
-/

variable (p q : α → Prop)

example : (∃ x : α, p x) → ¬(∀ x, ¬ p x) := by
  intros h h'
  cases h with
  | intro w hw =>
  specialize h' w
  contradiction

/- Exercise 9 -/
example : (∃ x : α, p x ∨ q x) → (∃ x : α, p x) ∨ (∃ x : α, q x) := sorry 

/- Exercise 10 -/
example : (∃ x : α, p x) ∨ (∃ x : α, q x) → (∃ x : α, p x ∨ q x) := sorry 

variable {β : Type} (r : α → β → Prop)
/- Exercise 11 -/
example : (∃ x : α, ∀ y : β, r x y) → (∀ y : β, ∃ x : α, r x y) := sorry 

/- Exercise 12 -/
example : (∀ x, p x) → ¬(∃ x, ¬p x) := sorry 
