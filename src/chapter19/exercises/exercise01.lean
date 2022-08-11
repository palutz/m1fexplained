import tactic
import data.real.sqrt
import data.int.modeq

/-

For each of the following functions `f`, say whether `f` is `1-1` and whether `f`
is `onto`.

-/

def f1 (x : ℝ) : ℝ := x^2 + 2*x

noncomputable def f2 (x : ℝ) : ℝ := 
  if 1 < x then x - 2 
  else if x < -1 then x + 2
  else -x

noncomputable def f3 (x : ℚ) : ℝ := (x + real.sqrt 2)^2

def f4 (mnr : ℕ × ℕ × ℕ) : ℕ := 
let ⟨m, n, r⟩ := mnr in
2 ^ m * 3 ^ n * 5 ^ r

def f5 (mnr : ℕ × ℕ × ℕ) : ℕ := 
let ⟨m, n, r⟩ := mnr in
2 ^ m * 3 ^ n * 6 ^ r

-- For the last question let's first make the equivalence relation
def e (a b : ℤ) : Prop := a ≡ b [ZMOD 7]

lemma he : equivalence e :=
⟨ 
  -- reflexive
  begin
    intro x,
    unfold e,
  end,
  -- symmetric
  begin
    intros x y h,
    unfold e at *,
    exact int.modeq.symm h,
  end,
  -- transitive
  begin
    intros x y z hxy hyz,
    unfold e at *,
    exact int.modeq.trans hxy hyz,
  end ⟩

-- Let's now say that `e` is the "canonical" equivalence relation on ℤ
instance s : setoid ℤ := ⟨e, he⟩

lemma s_def (a b : ℤ) : a ≈ b ↔ a ≡ b [ZMOD 7]:= iff.rfl

-- and now we can use the theory of quotients. The set `S` in the question
-- is called `quotient s` here. 

def f6 (x : quotient s) : quotient s :=
quotient.map (λ t : ℤ, t + 1) begin
  -- Lean points out that if we don't show the below, then `f6` isn't well-defined!
  show ∀ a b : ℤ, a ≈ b → a + 1 ≈ b + 1,
  -- So we have to prove it now.
  intros a b hab,
  rw s_def at *,
  exact int.modeq.add_right 1 hab,
end x

-- `injective` is actually called `function.injective` so let's open `function`
open function

-- now we can just call it `injective`

/-

## The rules

If the functions are injective/surjective, prove the lemmas. If they're not,
then put `¬` in front of them (e.g. `exercise01inj : ¬ (injective f1)` and prove
that instead!

-/
lemma exercise01inj : ¬ (injective f1) :=
begin
  intro h,
  have hp : f1 (-2) = f1 0,
  {unfold f1, norm_num},
  specialize h hp,
  norm_num at h,
end

lemma exercise01surj : ¬ (surjective f1) :=
begin
  intro h,
  specialize h (-2),
  cases h with x hx,
  unfold f1 at hx,
  have hp : ∀ x : ℝ, x ^ 2 + 2 * x = -2 ↔ (x + 1)^2 = -1,
  {intro x, split, {intro h1, linear_combination h1},
  {intros h2, linear_combination h2},
  },
  specialize hp x,
  rw hp at hx,
  nlinarith,
end

lemma exercise02inj : ¬ (injective f2) :=
begin
  intro h,
  have hp : f2 (-1/2) = f2 (5/2),
  {unfold f2, split_ifs; linarith},
  specialize h hp,
  norm_num at h,
end

lemma exercise02surj : (surjective f2) :=
begin
  intro y,
  rcases lt_trichotomy y 0 with h1 | rfl | h3,
  {use (y-2), unfold f2, split_ifs; linarith},
  {use 0, unfold f2, split_ifs; linarith},
  {use (y+2), unfold f2, split_ifs; linarith},
end

lemma exercise03inj : injective f3 :=
begin
  intros a b hab,
  unfold f3 at hab,
  sorry
end

lemma exercise03surj : ¬ (surjective f3) :=
begin
  intro h,
  specialize h (-1),
  cases h with x h,
  unfold f3 at h,
  sorry,
end

lemma exercise04inj : injective f4 :=
begin
  intros x y h,
  unfold f4 at h,
  sorry,
end

lemma exercise04surj : ¬ (surjective f4) :=
begin
  intro h,
  specialize h 7,
  cases h with x h,
  unfold f4 at h,
  sorry,
end

lemma exercise05inj : ¬ (injective f5) :=
begin
  intro h,
  specialize h ⟨1,1,1⟩ ⟨2,2,0⟩,
  sorry,
end

lemma exercise05surj : ¬ (surjective f5) :=
begin
  intro h,
  specialize h 5,
  cases h with x h,
  unfold f5 at h,
  sorry,
end

lemma exercise06inj : injective f6 :=
begin
  intros a b hab,
  unfold f6 at hab,
  sorry,
end

lemma exercise06surj : surjective f6 :=
begin
  intro y,
  use (quotient (s-1)),
  sorry,
end