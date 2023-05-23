### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 66710485-118d-42cd-879f-c94feb016449
using PyCall

# ╔═╡ 0a09f936-6f2e-4a1a-83e6-cfbcce8fec3f
using PlutoUI

# ╔═╡ 1854cd93-3f64-44a6-bf06-726a6b46e20c
using BenchmarkTools

# ╔═╡ 7988793d-f863-403a-a8bf-99af60b833b3
html"""
<style>
	@media screen {
		main {
			margin: 0 auto;
			max-width: 2000px;
    		padding-left: max(100px, 10%);
    		padding-right: max(100px, 10%); 
            # 383px to accomodate TableOfContents(aside=true)
		}
	}
</style>
"""

# ╔═╡ eb948d9e-f8af-11ed-1b53-050af478a6b1
md"# Speed 🐇"

# ╔═╡ bdded4dd-a4a5-484e-ae80-03a684f61942


# ╔═╡ c53a1cb7-ff2a-4387-983a-63c1d821303b
md"""


Before we start, let's address the typical question ([Julia FAQ](https://docs.julialang.org/en/v1/manual/faq/)):
### Why don't you compile Matlab/Python/R/… code to Julia?
> Julia's performance advantage derives almost entirely from its front-end: its language semantics allow a well-written Julia program to give more opportunities to the compiler to generate efficient code and memory layouts.
and
> Julia's advantage is that good performance is not limited to a small subset of “built-in” types and operations, and one can write high-level type-generic code that works on arbitrary user-defined types while remaining fast and memory-efficient. 
"""

# ╔═╡ 0847b58b-9e2a-4de4-8286-e41660782e0e


# ╔═╡ 1ee25f68-4228-43e4-8450-527cd5a05464


# ╔═╡ c2f2c406-b8de-4a04-8488-734556c173f8
md"## Naive comparison of `for`-loop performance"

# ╔═╡ 383b3372-7565-4bb8-96b8-6e219c0de110
md"#### Julia code"

# ╔═╡ cc33eb45-f6cd-4388-9d1f-d32be8e3ef55
function sum_entries(x)
	z = 0.0
	for i in eachindex(x)
		z += x[i]
	end
	return z
end

# ╔═╡ e0a95e06-82d9-42bf-8aa1-0ba8e9f64baf
md"#### Python code"

# ╔═╡ e38f79aa-9a66-4a25-a6da-f4040703e33c
md"""
```python
from timeit import default_timer as timer
import numpy as np

def sum_entries(x):
	z = 0.0
	for i in range(len(x)):
		z += x[i]
	return z

def measure_runtime(n):
	start = timer()
	sum_entries(np.random.rand(n))
	end = timer()
	return end - start

measure_runtime(1_000_000)
```
"""

# ╔═╡ 3827cf5d-2a7d-48cc-8f9f-21482fba54fa
python_runtime = begin
	py"""
	from timeit import default_timer as timer
	import numpy as np

	def get_x(x, i):
		return x[i]
	
	def sum_entries(x):
		z = 0.0
		for i in range(len(x)):
			z += x[i]
		return z

	def measure_runtime(n):
		start = timer()
		sum_entries(np.random.rand(n))
		end = timer()
		return end - start

	measure_runtime(1_000_000)
	"""
	@elapsed py"""measure_runtime(1_000_000)"""
end

# ╔═╡ 00ade30c-31f4-48b2-a252-feaaafaeabfc
julia_runtime = @elapsed sum_entries(rand(1_000_000));

# ╔═╡ 6dbb6fc1-1792-49a8-bdb9-20c96b8ef750
print("Python: ", python_runtime, "   Julia: ", julia_runtime, "   (seconds)")

# ╔═╡ fdd6d156-092d-4a32-bbce-f906e51413f5
md"#### 🚤 ~$(round(python_runtime / julia_runtime, digits = 2)) times faster"

# ╔═╡ b57cab60-2ddc-4822-85f1-cd4b83d79a3e


# ╔═╡ b77e10e5-d372-4d03-a148-8feb578b7d99
md"""## The **two-language** problem. 

Figure 1.B from _Julia for biologists_:"""

# ╔═╡ 28bd161e-87d4-4f62-9eb2-bb0d06c03f5d
LocalResource("figure_B.png")

# ╔═╡ 6ede1bfc-675e-4632-bcb5-6a5e8f66c697
md"### Example: Performance of custom functions"

# ╔═╡ d076c834-9987-4c22-af11-83f5d5c901de
md"Figure 3.C"

# ╔═╡ 4d52bdaf-4a0f-4873-81c5-fd298e9a5578
LocalResource("figure_3_c.png")

# ╔═╡ 880cc770-3b3c-47a3-ab87-ae863f2d7e1c


# ╔═╡ 99488d27-59cd-4e5a-928a-0a9a886102c2


# ╔═╡ 52ba2309-07a3-40d5-98e4-e7eeac233252
md"# Why does speed matter for science?

The actual _speed_ from initial idea to final result typically depends on factors:
- speed of coding
- speed of execution

Projects have multiple stages:
1. Development _(speed of coding)_
2. Testing and refinement _(speed of coding & execution)_
3. Application _(speed of execution)_

> _In research:_ Development and testing can be $10 - 100$ times more costly (in computational terms) than the actual application.

### Speed matters
- faster code enables better analysis (better testing, more samples, ...)
- in some applications, high performance is a requirement. 

"

# ╔═╡ 22235a60-3b1c-4632-aa04-d61479361267


# ╔═╡ 3e98adba-cb9f-459c-9478-f7ecdfaf726c


# ╔═╡ 312c02af-d673-4948-be02-630e1116993f


# ╔═╡ c91faaf7-21aa-4f00-ab0d-5cc274669786
md""" ## Beyond `for`-loops

Optimizing simple `for`-loops is doable (see `LuaJIT` or `@jit` from `numba`).

Dealing with complex situations is a whole different story:
- Plots
- Custom data types
- User-defined functions
- Recursion
- **Runtime dependent information**
"""

# ╔═╡ 80ba7648-4190-47b8-b67e-9e1c5bc2b6c8
Resource("https://rare-gallery.com/uploads/posts/1160083-drawing-illustration-animals-lizards-artwork-symmetry-pattern-circle-optical-illusion-M-C-Escher-ART-design-modern-art-font.jpg")

# ╔═╡ cea0b3ee-4fe7-4f1b-aa17-21e67410b47d


# ╔═╡ 6a894f12-e759-4fe4-9ed9-06e507c42d26


# ╔═╡ ad4b22b8-6c16-49cf-be87-865d6ea7e4ab
md"Figure 1.C: **Limitations for high performance applications:**"

# ╔═╡ 4388c579-39b6-4891-a3b0-41b7b30c8a7c
LocalResource("figure_c.png")

# ╔═╡ fe4a6258-1932-4b7a-9c96-d5be38f3db68


# ╔═╡ 2d5fde9f-ae8d-438d-b3a7-1c52666918ed


# ╔═╡ 682c8938-4eca-4684-a733-c0b3366a8995


# ╔═╡ 84d23926-6218-4c6f-9427-a6ca36f9ffa1
md"""
### Example: Custom types

In the following, we want to represent a "cell" by it's position, radius and phenotype.

> **Main challenge:** The `phenotype` of different cells can have a different data type, as different phenotypes might provide different information.
"""

# ╔═╡ 98a0789d-accb-4462-a090-733a0dd140af
struct Cell{CellType}
	x::Float64
	y::Float64
	radius::Float64
	phenotype::CellType   # CellType is a placeholder for the actual type used!
end

# ╔═╡ 99e68ba8-eada-48f4-94d6-b74aab64f9d7
cell_1 = Cell(0.0, 5.2, 10.0, nothing)

# ╔═╡ faeed1b6-693b-4de3-8e00-965a3e460f37
cell_2 = Cell(-5.2, 0., 10.0, (age = 10.0,))

# ╔═╡ 5cfb47fd-fe43-4576-acd0-5db41a4a4b46


# ╔═╡ 85812632-650c-400f-a1a1-9eed03c83828


# ╔═╡ fb437f6d-9b57-47b9-a6e9-d965ee530d2a
md"""
#### Performance of custom data types

Typically, custom data types are challenging since:
- memory layout is unclear
- different types need different functions

However, below we will see that Julia semantics provides all information the compiler needs:

"""

# ╔═╡ caf8e100-3a3b-4295-b523-609d5ae4988b
md"#### 1. Memory layout:
"

# ╔═╡ 53e88efd-0b8a-4f14-896b-e9d92a72d2b0
md"""
> A unknown memory layout is like visiting a person for the first time: you need to ask for the address ❓, search the address on maps 🗾, go there 🚶, get lost 😕, call the person to ask for directions 🤙, ...

whereas

> A known memory layout is like going home: You know where to go, probably even the fastest way (bullet train?) 🚄
"""

# ╔═╡ 0d450987-54be-4e1b-a3f9-fbef44ba1098


# ╔═╡ f67fc15a-f62c-4d2e-a054-ed7eaccdee9a
md"""_Examples:_

Every type which `isbitstype` has a clearly defined `C`-like memory layout:"""

# ╔═╡ 948050b3-7e5b-45fd-87d2-50b9d5243978
isbits(cell_1)

# ╔═╡ 7ef2ef40-913e-4035-b7c8-dbea8a5c381f
md"As a result, the following operations have optimal performance:"

# ╔═╡ 2881482d-7595-4d4a-8058-fc45609a3129
sizeof(cell_1)  # cell_1 has in total 24 bytes -> 192 bits

# ╔═╡ 5c549f34-dc6e-49d9-b281-a164d8a32caa
cell_1.x   # -> memory location starts at the first bit of cell 1

# ╔═╡ 64954f4f-83cb-4e34-b331-e462b8fd0013
sizeof(cell_2)  # cell_2 has in total 32 bytes

# ╔═╡ 867e431d-c541-4483-b8df-410127d7e143
cell_2.phenotype.age   # -> memory location starts at bit 193

# ╔═╡ 6b7289f2-6080-4b65-9613-3f38bf84436e


# ╔═╡ a8626abb-be93-4440-a3ba-94e8b0d78d57


# ╔═╡ da06d38a-fa00-4f95-ad6d-248086e7bba5
md"""
#### 2. Single dispatch

We can define functions for **any type**!
"""

# ╔═╡ 96a9cab9-d8f7-41c5-b8f5-7c340d6c881f
function area(cell::Cell)
	return π * cell.radius^2
end

# ╔═╡ 627d32ea-1c2e-401e-b290-7bcf0bc8d789
md" ➡ `area` is fast for both `cell_1` and `cell_2`!"

# ╔═╡ 19d02aa8-2c15-4a75-b689-36ab5766bb34


# ╔═╡ b91df15d-d406-497a-9848-41fa6df8e132
md"We can overwrite the behaviour by further specifying the data types in functins!"

# ╔═╡ f88afa78-057f-47a8-b595-20118db7e955
const CellType1 = typeof(cell_1);

# ╔═╡ 242400ac-0b63-4718-86a1-d1daf593628f
const CellType2 = typeof(cell_2);

# ╔═╡ e62d78ef-d613-4a49-9d60-b083e8dffd51


# ╔═╡ f31f8ac2-3c40-493d-bf2c-23e61a271c94
function area(cell::CellType2)
	r = cell.radius * (1 + cell.phenotype.age / 40)
	return π * r^2
end

# ╔═╡ 316f3093-84b2-4779-96f4-755aa80b0dfb


# ╔═╡ f75333e6-7b5f-4180-b1f2-aaa55fcd0d4b
area(cell_1)

# ╔═╡ 7683eaf1-d29f-45ef-a6ee-e75ede25558a
area(cell_2)

# ╔═╡ 00354f13-5a60-48fe-a835-cc33650aba3a


# ╔═╡ e4f1b44a-a9a6-4b90-aba8-19b11c323102


# ╔═╡ f4b3de50-472a-4bcc-8c88-e49f68ab30b3
md"### 3. Effective runtime dispatch

One of the biggest challenges with dynamic types is that the evaluation path of a program can change at runtime. This makes everything unpredictable. 

One of Julia's core strengths is to use as much of the given type information to provide optimal execution times.
"

# ╔═╡ 5324c6d8-5a5c-47d8-b8c9-98a76398d532


# ╔═╡ e07f974a-08cf-4686-b3b6-7fb99dc3e069
hom_cells = [ Cell(rand(2)..., 10.0, nothing) for i in 1:1000 ]

# ╔═╡ c66f260a-4dfd-49db-a1ee-bb9242278381


# ╔═╡ c111d8cb-8095-4525-afeb-a7e6ea9380df
md"Let's mix two cell types:"

# ╔═╡ 859ab38c-d914-4628-b264-f0f1ab77d2df
UnionType = Union{CellType1,CellType2};

# ╔═╡ efcc91c4-5e77-4193-b3f5-ff71d264d209
function random_cell() 
	Cell(rand(2)..., 10.0, rand() < 0.5 ? (age = rand(), ) : nothing)
end;

# ╔═╡ 263dcfb7-df19-43b2-885b-db984195fd8a
hetr_cells = UnionType[random_cell() for i in 1:1000 ]

# ╔═╡ 14159c57-2f93-4b37-bac2-eafd5ca9e830


# ╔═╡ 96dfbe23-a7e5-4095-8105-ae6013187a7e


# ╔═╡ 9fd25c48-8dca-4c6d-ab60-0313ec43e3d4
function test_speed(cells)
	total_area = 0.0
	for c in cells
		total_area += area(c)
	end
	return total_area
end

# ╔═╡ 6d2e7105-e0e0-43b5-ba05-ad0625bd01e5
@btime test_speed($hom_cells);

# ╔═╡ 0f517c58-6390-41f4-b6f4-b520305e8935
@btime test_speed($hetr_cells);

# ╔═╡ 48324c33-50fd-46ef-bcd3-ae8af2f1c620


# ╔═╡ 60e4fa7b-d0f5-4d45-96ad-dd11e59260a3
md"""
### 4. Multiple dispatch

> The fundamental difference between Julia compared to most other programming languages is **multiple dispatch**.
"""

# ╔═╡ 94808a81-3dc9-4e2f-9442-073343d43eba
begin
	adhesion_strength(c1::Cell, c2::Cell) = 10.0
	adhesion_strength(c1::CellType2, c2::CellType2) = 5.0
	adhesion_strength(c1::CellType2, c2::Cell) = 0.0
	adhesion_strength(c1::Cell, c2::CellType2) = 0.0
end

# ╔═╡ 4e1c2dab-b077-4f62-bfad-f55173bb2987
sum( adhesion_strength.(hom_cells, hom_cells) )

# ╔═╡ 8f8ae940-fef5-492e-815a-d8fb9eec6901


# ╔═╡ 2e0fe3e4-09ab-4cc9-9ad6-85fe8eaf2a77
hetr_cells_2 = UnionType[ random_cell() for i in 1:1000 ];

# ╔═╡ 2f025e48-c541-43ec-9698-698fc8d56fa6
sum( adhesion_strength.(hetr_cells, hetr_cells_2) )

# ╔═╡ 835d2de4-2920-4286-8738-c53404c3a148


# ╔═╡ 3e4653c5-7366-4779-9e19-304cc5418beb


# ╔═╡ ddf6b74e-1dbd-4435-9181-895eeadd97ac
md"### With multiple dispatch we can express essentially all possible evaluation paths"

# ╔═╡ a8daa1c8-ffce-4096-bc51-6fb1da5124a0
md" ### $\Rightarrow$ and Julia can optimize accordingly."

# ╔═╡ 2c04f821-dd51-4962-a5eb-dca00b13c9c4


# ╔═╡ e4ac1334-b748-4781-8be4-f9e02e5f4245
md"_(quick speed test)_"

# ╔═╡ b404c8fd-18c7-42e7-ad06-b02f6e6ef78a
begin
	@btime sum( (c) -> adhesion_strength(c[1],c[2]), zip($hom_cells, $hom_cells))

	
	@btime sum( (c) -> adhesion_strength(c[1],c[2]), zip($hetr_cells, $hetr_cells_2))
end;

# ╔═╡ ad6d76e9-6542-450d-b241-2ce7d2ac4b25


# ╔═╡ eeb17039-81a2-4b34-86f6-83c8e0d0ba2c


# ╔═╡ 8ff8e454-b39c-428e-844c-54dbac7389ef
md" ### $\Rightarrow$ Takeaway: _We have everything needed to make custom datatypes fast, even in non-homogeneous situations._ 🥳"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
BenchmarkTools = "~1.3.2"
PlutoUI = "~0.7.51"
PyCall = "~1.95.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-rc1"
manifest_format = "2.0"
project_hash = "2d8471dc199bdd1cb8bd9c70dfa4fe4dca0d30ed"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "e32a90da027ca45d84678b826fffd3110bb3fc90"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.8.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a5aef8d4a6e8d81f171b2bd4be5265b01384c74c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.10"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "259e206946c293698122f63e2b513a7c99a244e8"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "62f417f6ad727987c755549e9cd88c46578da562"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.95.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.4.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─7988793d-f863-403a-a8bf-99af60b833b3
# ╟─eb948d9e-f8af-11ed-1b53-050af478a6b1
# ╟─bdded4dd-a4a5-484e-ae80-03a684f61942
# ╟─c53a1cb7-ff2a-4387-983a-63c1d821303b
# ╟─0847b58b-9e2a-4de4-8286-e41660782e0e
# ╟─1ee25f68-4228-43e4-8450-527cd5a05464
# ╟─c2f2c406-b8de-4a04-8488-734556c173f8
# ╟─383b3372-7565-4bb8-96b8-6e219c0de110
# ╠═cc33eb45-f6cd-4388-9d1f-d32be8e3ef55
# ╟─e0a95e06-82d9-42bf-8aa1-0ba8e9f64baf
# ╠═66710485-118d-42cd-879f-c94feb016449
# ╟─e38f79aa-9a66-4a25-a6da-f4040703e33c
# ╟─3827cf5d-2a7d-48cc-8f9f-21482fba54fa
# ╠═00ade30c-31f4-48b2-a252-feaaafaeabfc
# ╟─6dbb6fc1-1792-49a8-bdb9-20c96b8ef750
# ╟─fdd6d156-092d-4a32-bbce-f906e51413f5
# ╟─b57cab60-2ddc-4822-85f1-cd4b83d79a3e
# ╟─b77e10e5-d372-4d03-a148-8feb578b7d99
# ╟─28bd161e-87d4-4f62-9eb2-bb0d06c03f5d
# ╟─0a09f936-6f2e-4a1a-83e6-cfbcce8fec3f
# ╟─6ede1bfc-675e-4632-bcb5-6a5e8f66c697
# ╟─d076c834-9987-4c22-af11-83f5d5c901de
# ╟─4d52bdaf-4a0f-4873-81c5-fd298e9a5578
# ╟─880cc770-3b3c-47a3-ab87-ae863f2d7e1c
# ╟─99488d27-59cd-4e5a-928a-0a9a886102c2
# ╟─52ba2309-07a3-40d5-98e4-e7eeac233252
# ╟─22235a60-3b1c-4632-aa04-d61479361267
# ╟─3e98adba-cb9f-459c-9478-f7ecdfaf726c
# ╟─312c02af-d673-4948-be02-630e1116993f
# ╟─c91faaf7-21aa-4f00-ab0d-5cc274669786
# ╟─80ba7648-4190-47b8-b67e-9e1c5bc2b6c8
# ╟─cea0b3ee-4fe7-4f1b-aa17-21e67410b47d
# ╟─6a894f12-e759-4fe4-9ed9-06e507c42d26
# ╟─ad4b22b8-6c16-49cf-be87-865d6ea7e4ab
# ╟─4388c579-39b6-4891-a3b0-41b7b30c8a7c
# ╟─fe4a6258-1932-4b7a-9c96-d5be38f3db68
# ╟─2d5fde9f-ae8d-438d-b3a7-1c52666918ed
# ╟─682c8938-4eca-4684-a733-c0b3366a8995
# ╟─84d23926-6218-4c6f-9427-a6ca36f9ffa1
# ╠═98a0789d-accb-4462-a090-733a0dd140af
# ╠═99e68ba8-eada-48f4-94d6-b74aab64f9d7
# ╠═faeed1b6-693b-4de3-8e00-965a3e460f37
# ╟─5cfb47fd-fe43-4576-acd0-5db41a4a4b46
# ╟─85812632-650c-400f-a1a1-9eed03c83828
# ╟─fb437f6d-9b57-47b9-a6e9-d965ee530d2a
# ╟─caf8e100-3a3b-4295-b523-609d5ae4988b
# ╟─53e88efd-0b8a-4f14-896b-e9d92a72d2b0
# ╟─0d450987-54be-4e1b-a3f9-fbef44ba1098
# ╟─f67fc15a-f62c-4d2e-a054-ed7eaccdee9a
# ╠═948050b3-7e5b-45fd-87d2-50b9d5243978
# ╟─7ef2ef40-913e-4035-b7c8-dbea8a5c381f
# ╠═2881482d-7595-4d4a-8058-fc45609a3129
# ╠═5c549f34-dc6e-49d9-b281-a164d8a32caa
# ╠═64954f4f-83cb-4e34-b331-e462b8fd0013
# ╠═867e431d-c541-4483-b8df-410127d7e143
# ╟─6b7289f2-6080-4b65-9613-3f38bf84436e
# ╟─a8626abb-be93-4440-a3ba-94e8b0d78d57
# ╟─da06d38a-fa00-4f95-ad6d-248086e7bba5
# ╠═96a9cab9-d8f7-41c5-b8f5-7c340d6c881f
# ╟─627d32ea-1c2e-401e-b290-7bcf0bc8d789
# ╟─19d02aa8-2c15-4a75-b689-36ab5766bb34
# ╟─b91df15d-d406-497a-9848-41fa6df8e132
# ╠═f88afa78-057f-47a8-b595-20118db7e955
# ╠═242400ac-0b63-4718-86a1-d1daf593628f
# ╟─e62d78ef-d613-4a49-9d60-b083e8dffd51
# ╠═f31f8ac2-3c40-493d-bf2c-23e61a271c94
# ╟─316f3093-84b2-4779-96f4-755aa80b0dfb
# ╠═f75333e6-7b5f-4180-b1f2-aaa55fcd0d4b
# ╠═7683eaf1-d29f-45ef-a6ee-e75ede25558a
# ╟─00354f13-5a60-48fe-a835-cc33650aba3a
# ╟─e4f1b44a-a9a6-4b90-aba8-19b11c323102
# ╟─f4b3de50-472a-4bcc-8c88-e49f68ab30b3
# ╟─5324c6d8-5a5c-47d8-b8c9-98a76398d532
# ╠═e07f974a-08cf-4686-b3b6-7fb99dc3e069
# ╟─c66f260a-4dfd-49db-a1ee-bb9242278381
# ╟─c111d8cb-8095-4525-afeb-a7e6ea9380df
# ╠═859ab38c-d914-4628-b264-f0f1ab77d2df
# ╠═efcc91c4-5e77-4193-b3f5-ff71d264d209
# ╠═263dcfb7-df19-43b2-885b-db984195fd8a
# ╟─14159c57-2f93-4b37-bac2-eafd5ca9e830
# ╟─96dfbe23-a7e5-4095-8105-ae6013187a7e
# ╠═9fd25c48-8dca-4c6d-ab60-0313ec43e3d4
# ╠═1854cd93-3f64-44a6-bf06-726a6b46e20c
# ╠═6d2e7105-e0e0-43b5-ba05-ad0625bd01e5
# ╠═0f517c58-6390-41f4-b6f4-b520305e8935
# ╟─48324c33-50fd-46ef-bcd3-ae8af2f1c620
# ╟─60e4fa7b-d0f5-4d45-96ad-dd11e59260a3
# ╠═94808a81-3dc9-4e2f-9442-073343d43eba
# ╠═4e1c2dab-b077-4f62-bfad-f55173bb2987
# ╟─8f8ae940-fef5-492e-815a-d8fb9eec6901
# ╠═2e0fe3e4-09ab-4cc9-9ad6-85fe8eaf2a77
# ╠═2f025e48-c541-43ec-9698-698fc8d56fa6
# ╟─835d2de4-2920-4286-8738-c53404c3a148
# ╟─3e4653c5-7366-4779-9e19-304cc5418beb
# ╟─ddf6b74e-1dbd-4435-9181-895eeadd97ac
# ╟─a8daa1c8-ffce-4096-bc51-6fb1da5124a0
# ╟─2c04f821-dd51-4962-a5eb-dca00b13c9c4
# ╟─e4ac1334-b748-4781-8be4-f9e02e5f4245
# ╟─b404c8fd-18c7-42e7-ad06-b02f6e6ef78a
# ╟─ad6d76e9-6542-450d-b241-2ce7d2ac4b25
# ╟─eeb17039-81a2-4b34-86f6-83c8e0d0ba2c
# ╟─8ff8e454-b39c-428e-844c-54dbac7389ef
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
