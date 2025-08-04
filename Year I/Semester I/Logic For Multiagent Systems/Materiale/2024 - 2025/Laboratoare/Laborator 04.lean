macro "use" e:term : tactic => `(tactic| refine Exists.intro $e ?_)

set_option autoImplicit false

/- **Classical logic** -/


section
/-
  Most proofs we have seen so far follow the pattern of noticing what the top-most
  logical construct in the goal is, and the applying its corresponding introduction principle
  in order to remove it and simplify the goal, until we reach something trivial.
  For example, if the goal is of the form `p ∧ q`, it is usually a good idea
  to first think of `apply`ing `And.intro`, and analogously for the other connectives.

  However, the strategy of blindly applying introduction principles until the end does not always work.
-/
  variable {p q : Prop}

  #check Classical.em

  example : ¬(p ∧ q) → ¬p ∨ ¬q := by
    intros h
    -- We are stuck. We could applying `Or.inl` or `Or.inr`, but there is no way to proceed afterwards. We need something extra.
    by_cases h' : p -- the `by_cases` tactic will split the proof in two cases:
                    -- one where `p` is assumed to be true, and one where it assumed to be false.
    . apply Or.inr
      intros hq
      have hpq : p ∧ q := by
        exact And.intro h' hq
      -- `have` allows us to add a new hypothesis (with a proof) in our local context
      -- Here, because we know `p` and `q`, we can add the hypothesis `p ∧ q`.
      contradiction
    . apply Or.inl
      assumption

  /- Exercise 1 -/
  example : ¬¬p → p := sorry

  /- Exercise 2 -/
  example : (p → q) → (¬p ∨ q) := sorry

  /- Exercise 3 -/
  example : (¬p → ¬q) → (q → p) := sorry

end

section variable {α : Type} {p : α → Prop}


  /- In exercise 6 of Lab3 we proved that `(∀ x : Nat, p x) → (∃ x : Nat, p x)`.
     This not only true for predicates on `Nat` but on other types too.
     *Before scrolling down*, is it true that for any type `α`, `(∀ x : α, p x) → (∃ x : α, p x)` holds?
     If not, can you think of a counterexample and of a condition that `α` needs to satisfy in order for the statement to be true?
  -/


  /- The needed condition is for `α` to be nonempty. This condition is expressed in Lean as below, called `Inhabited α`.
     This allows one to use the `default` function that returns an arbitrary element of type `α`, which can be used as a witness below.
  -/
  example [Inhabited α] : (∀ x : α, p x) → (∃ x : α, p x) := by
    intros h
    use default
    specialize h default
    assumption



end


/- **Quantifying over proposition**-/

/-
  Lean is not limited to first-order logic, as noticed for example by the fact that one may
  form proposition that quantify over `Prop` itself.
  For instance, exercise 6 shows an equivalent characterization of `False`,
  as the proposition stating that all propositions are true.

  This "higher-order nature", also allows one (exercise 7, 8) to internally disprove
  logical principles that are false in general.
-/

section

  /- Exercise 6 -/
  example : (∀ p : Prop, p) ↔ False := sorry


  /- Exercise 7 -/
  example : ¬(∀ p q : Prop, p ∨ q → p ∧ q) := sorry

  /- Exercise 8 -/
  example : ¬(∀ (p q : Nat → Prop), (∀ x, p x ∨ q x) → (∀ x, p x) ∨ (∀ x, q x)) := sorry

end
