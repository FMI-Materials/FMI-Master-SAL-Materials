

macro "use" e:term : tactic => `(tactic| refine Exists.intro $e ?_)

set_option autoImplicit false

/-
  Lab Test - Logic for Multiagent systems

  Fill the `sorry`s below.
  You may **not** use the `simp` tactic (or its variations) or theorems from the standard library for
    the proofs in Exercises 2 ... 5.
  You are **not** allowed to import external libraries.

  Each exercise is worth 1 point.

  You can use a local Lean installation, or the web editor at: https://live.lean-lang.org/

  At the end, submit at: https://tinyurl.com/LMAS20245 one Lean file titled LastName_FirstName_Group.lean.
-/

/-
  **Exercise 1**: Define the `prodFrom : Nat → Nat → Nat` function
    such that, for all `a b : Nat`, `prodFrom a b` computes the product of the first `b` numbers starting from `a`. 
    In other words `prodFrom a b` is the product of the set `{a, a + 1, ..., a + (b - 1)}`,
    and we convene that an empty product computes to `1`.
  The definition must be given via structural recursion.
-/
def prodFrom (a : Nat) (b : Nat) : Nat := sorry 

-- It should pass the following tests 
example : prodFrom 3 0 = 1 := by rfl 
example : prodFrom 3 1 = 3 := by rfl 
example : prodFrom 3 3 = 60 := by rfl 


section
  variable (p q r : Prop)

/-
  **Exercise 2**: Prove the following theorem.
-/
  theorem ex2 : (p → q) → ¬¬(¬¬p → ¬¬q) ∧ (p ∨ r → q ∨ r) := sorry 
        

end


section

  variable (p : Nat → Prop) (q : Prop)

/-
  **Exercise 3**: Prove the following theorem.
-/
  theorem ex3 : (q → ∃ x, p x) ↔ (∃ x, (q → p x)) := sorry 


end


section
/-
  **Exercise 4**: Prove the following theorem.
-/
  theorem ex4 : ¬(∀ p : Prop, ¬(p ∧ p → ¬p)) := sorry 
    
end


section
  opaque Box : Prop → Prop

  prefix:max "□" => Box

  def Diamond (p : Prop) : Prop := ¬□¬p

  prefix:max "⋄" => Diamond

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
  theorem ex5 : (∀ {φ ψ : Prop}, (⊢K (φ → ψ)) → (⊢K (⋄φ → ⋄ψ))) → ((⊢K (¬p → ¬q)) → (⊢K (⋄q → ⋄p))) := sorry 
       
    
end
