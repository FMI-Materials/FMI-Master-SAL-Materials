macro "use" e:term : tactic => `(tactic| refine Exists.intro $e ?_)

set_option autoImplicit false

/-
  Lab Test - Logic for Multiagent systems

  Fill the `sorry`s below.
  You may **not** use the `simp` tactic or theorems from the standard library for
    the proofs in Exercises 2 ... 5.
  You are **not** allowed to import external libraries.

  Each exercise is worth 1 point.

  You can use a local Lean installation, or the web editor at: https://live.lean-lang.org/

  At the end, submit at: http://tinyurl.com/LMAS20234
    one Lean file titled LastName_FirstName_Group.
-/

/-
  **Exercise 1**: Define the `exp : Nat → Nat → Nat` function
    such that, for all `a b : Nat`, `exp a b` computes `aᵇ` (`a` to the power of `b`).
  The definition must be given via structural recursion.
  We follow the convention that 0⁰ = 1.
-/
def exp (a : Nat) (b : Nat) : Nat :=
  match b with
  | 0 => 1
  | Nat.succ b' => a * exp a b'

section
  variable (p q : Prop)

/-
  **Exercise 2**: Prove the following theorem.
-/
  theorem ex2 : ¬(p ∧ ¬¬q) → (p → ¬q) := by
    intros h hp gq
    have hnnq : ¬¬q := by
      intros hnq
      contradiction
    have : p ∧ ¬¬q := And.intro hp hnnq
    contradiction
end


section

  variable {α : Type} (p : α → Prop) (q : Prop)

/-
  **Exercise 3**: Prove the following theorem.
-/
  theorem ex3 : (∀ x, p x → q) ↔ ((∃ x, p x) → q) := by
    apply Iff.intro
    . intros h h'
      cases h' with
      | intro w hp =>
      specialize h w
      exact h hp
    . intros h x hp
      have : ∃ x, p x := by
        use x
        assumption
      exact h this
end


section
/-
  **Exercise 4**: Prove the following theorem.
-/
  theorem ex4 : ¬(∀ p q : Prop, (p → q) → (¬p → ¬q)) := by
    intros h
    specialize h False True
    contradiction
end


section
  opaque Box : Prop → Prop

  prefix:max "□" => Box

  set_option hygiene false in prefix:100 "⊢K" => KProvable
  inductive KProvable : Prop → Prop where
  | tautology {p : Prop} : p → ⊢K p
  | modusPonens {p q : Prop} : ⊢K p → ⊢K (p → q) → ⊢K q
  | K {p q : Prop} : ⊢K (□(p → q) → □p → □q)
  | necessitation {p : Prop} : ⊢K p → ⊢K □p

  open KProvable

  variable (p q r : Prop)
/-
  **Exercise 5**: Prove the following theorem.
-/
  theorem ex5 : ⊢K (□□(p ∨ q) → □□(q ∨ p)) := by
    have l₁ : p ∨ q → q ∨ p := by
      intros h
      cases h
      . apply Or.inr
        assumption
      . apply Or.inl
        assumption
    have l₂ : ⊢K (p ∨ q → q ∨ p) := tautology l₁
    have l₃ : ⊢K □(p ∨ q → q ∨ p) := necessitation l₂
    have l₄ : ⊢K (□(p ∨ q) → □(q ∨ p)) := modusPonens l₃ K
    have l₅ : ⊢K □(□(p ∨ q) → □(q ∨ p)) := necessitation l₄
    exact modusPonens l₅ K
end
