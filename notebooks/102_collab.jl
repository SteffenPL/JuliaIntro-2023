### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ b76ae1cc-2ec9-4452-8580-bab579ec4c1f
using PlutoUI

# ╔═╡ 613ebe50-f8be-11ed-3951-33533bb86855
md"# The conditions for good collaboration"

# ╔═╡ d48edcf3-4010-4ccc-948f-41104d8c073d
Resource("https://www.artic.edu/iiif/2/97a891c9-e3fc-71f5-059d-1ed3604da6ea/full/843,/0/default.jpg")

# ╔═╡ f6a6a5f2-49eb-4fc9-9b96-29acad0d22f0
md"_Une mauvaise cuisine_, Honoré-Victorin Daumier."

# ╔═╡ a09ace66-1b85-4b8a-9e64-f2120a429118


# ╔═╡ 7e8b4d9f-f432-420e-95f6-ca98707bc6c2


# ╔═╡ 10a1148e-29df-474b-a9f4-ace96424b6f9


# ╔═╡ d66deb72-c798-4dc6-a038-bceac755ab4a
md"## A programming drama in four acts.

_Two programmers, one better than the other, worked in peace without knowing about each other. When suddenly, their ideas began to overlap._
"

# ╔═╡ 650fa650-4033-4ee4-8716-9cd2d1377097


# ╔═╡ fc539b22-18bb-4fef-b045-38dd94158e63
md"## Act I: Innocent beginnings."

# ╔═╡ f68a85da-9419-4fb5-9706-e61406c7a625
md"#### _Euler said:_"

# ╔═╡ 00e47207-1731-4c8c-88d4-2509f56f2c11


# ╔═╡ 03510856-9772-45f9-a5ba-2b6df0eb197d
md"#### _Galilei defined:_"

# ╔═╡ 31be0b3d-1838-4d4f-9236-6fd32a45d309
struct Planet
	pos::Vector{Float64}
	vel::Vector{Float64}
	mass::Float64
end

# ╔═╡ f487583e-c5d4-4f5c-984a-61e34e6065b4
earth = Planet( [1.0,0.0], [2.0,0.0], 100.0)

# ╔═╡ 75b1c984-71de-407c-9a46-232e1a87b1cb


# ╔═╡ 6d17bd70-abfb-4ade-87da-5c066dac7a0d
md"## Act II: The conflict."

# ╔═╡ 4008576a-aa20-4736-986a-21b486b6e03f
md"#### Galilei tried Euler's method:"

# ╔═╡ 3d8adaba-8e11-4612-92b3-b40946880171
md"""#### Galilei cried:

> _"Oh Euler, oh Euler. Will you please change your function to integrate planets instead of vectors?"_

"""

# ╔═╡ d88d597e-1950-4e2b-a580-297fc04dade9
md"""#### Euler was not amused: 

> _"You fool, never will I change my beautiful mathematical scheme to fit your primitive attempts!"_
"""

# ╔═╡ e7417047-fb3d-41f5-a1a6-91930089cb36


# ╔═╡ 9e32c5f7-fe24-46ab-8d41-619d0718c137


# ╔═╡ 341871d5-364b-4bc6-9ebb-81331f64de47
md"## Act III: Splitting apart."

# ╔═╡ 37b58a98-2ebb-4757-8cca-9f433a8cb079
md"The scientific world was at shock. Will Galilei implement his own scheme?"

# ╔═╡ a04c2da8-a89a-4838-b7b3-89b3d7248c9e
md"> **The world is about to separate into two, almost identical, Julia packages. Years of research are about to duplicate if not even triple, if Euler and Galilei would not agree!** 😱"

# ╔═╡ 6ef866b7-b18e-475b-ac77-bb7646790dc3


# ╔═╡ d78afbbb-09fb-4a33-a4be-4c428d63ce89
md"## Act IV: Abstract resolution."

# ╔═╡ d74e95b7-368e-40c6-afc4-f0e8a3857cd9
md"#### Newton could not let the scientifc world break apart, again:"

# ╔═╡ a38df79e-06ed-413a-8d36-efefe812ec83
struct Tangent
	pos::Vector{Float64}
	vel::Vector{Float64}
end

# ╔═╡ 1dc9292e-5edc-4114-81f8-4efcb4bdb532
Base.:*(λ::Float64, v::Tangent) = Tangent(λ * v.pos, λ * v.vel)

# ╔═╡ 7edd0655-71ef-43c7-a839-b9fdfaa4ec3b
Base.:+(p::Planet, v::Tangent) = Planet(p.pos + v.vel, p.vel + v.vel, p.mass) 

# ╔═╡ bddd4319-13c7-4711-b864-e57a67565173
function euler(f, u0, tspan, dt)
	u = deepcopy(u0)
	sol = [u0]
	k = 1
	t = tspan[1]

	while t < tspan[2]
		t += dt
		u = u + dt * f(u0)
		push!(sol, u)
	end
	return sol
end

# ╔═╡ ed128b5a-5352-4660-99b1-71b5fefd66f9
euler( (u) -> -u, [1.0, 2.0], [0,10], 0.1)

# ╔═╡ 43ea3f6d-86c1-4e41-9496-8cba33b79234
euler(planet -> -planet.pos, earth, [0,10], 0.1)

# ╔═╡ 2891e58d-8472-468d-b852-57296403416b
function galilei(f, u0, tspan, dt)
	u = deepcopy(u0)
	sol = [u0]
	k = 1
	t = tspan[1]

	while t < tspan[2]
		t += dt
		u.vel += dt * f(u.pos) / u.mass
		u.pos += dt * u.vel 
		push!(sol, u)
	end
	return sol
end

# ╔═╡ dcd80ebf-e023-476d-bde5-26c6357457af
newton(fnc) =(planet -> Tangent(planet.vel, fnc(planet) / planet.mass ) )

# ╔═╡ 9c9e39b6-7cda-459e-8e15-3d580ffe5ee7


# ╔═╡ 2be5d46c-e053-4077-885c-29011cec2fc9
md"#### Unite, you fools!"

# ╔═╡ 19f650b2-89e6-43a2-8680-bf7f01cf2630
euler( newton(planet -> -planet.pos), earth, [0, 10], 0.1 )

# ╔═╡ d9369c5c-8159-4d43-8a88-491cf0116332
md" > Some critics, including Galilei, tried to find a weak spot. **But the new solution was as fast and elegant enough**, such that the dust quickly settled."

# ╔═╡ 92f4d247-fac6-41c4-b907-01839855c7f5


# ╔═╡ f8536c10-03f8-4ef8-938a-6259143a1d57
md"_Thereforth, the scientific world united and used the `euler` method..._"

# ╔═╡ 4bae8ee5-2ae8-43f4-afdf-9ebdcd8619b6
md"### _The end._"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-rc1"
manifest_format = "2.0"
project_hash = "dcebd3174a85b0f68c71e8431fe1914ebcbe8db2"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

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
# ╟─b76ae1cc-2ec9-4452-8580-bab579ec4c1f
# ╟─613ebe50-f8be-11ed-3951-33533bb86855
# ╟─d48edcf3-4010-4ccc-948f-41104d8c073d
# ╟─f6a6a5f2-49eb-4fc9-9b96-29acad0d22f0
# ╟─a09ace66-1b85-4b8a-9e64-f2120a429118
# ╟─7e8b4d9f-f432-420e-95f6-ca98707bc6c2
# ╟─10a1148e-29df-474b-a9f4-ace96424b6f9
# ╟─d66deb72-c798-4dc6-a038-bceac755ab4a
# ╟─650fa650-4033-4ee4-8716-9cd2d1377097
# ╟─fc539b22-18bb-4fef-b045-38dd94158e63
# ╟─f68a85da-9419-4fb5-9706-e61406c7a625
# ╠═bddd4319-13c7-4711-b864-e57a67565173
# ╠═ed128b5a-5352-4660-99b1-71b5fefd66f9
# ╟─00e47207-1731-4c8c-88d4-2509f56f2c11
# ╟─03510856-9772-45f9-a5ba-2b6df0eb197d
# ╠═31be0b3d-1838-4d4f-9236-6fd32a45d309
# ╠═f487583e-c5d4-4f5c-984a-61e34e6065b4
# ╟─75b1c984-71de-407c-9a46-232e1a87b1cb
# ╟─6d17bd70-abfb-4ade-87da-5c066dac7a0d
# ╟─4008576a-aa20-4736-986a-21b486b6e03f
# ╠═43ea3f6d-86c1-4e41-9496-8cba33b79234
# ╟─3d8adaba-8e11-4612-92b3-b40946880171
# ╟─d88d597e-1950-4e2b-a580-297fc04dade9
# ╟─e7417047-fb3d-41f5-a1a6-91930089cb36
# ╟─9e32c5f7-fe24-46ab-8d41-619d0718c137
# ╟─341871d5-364b-4bc6-9ebb-81331f64de47
# ╟─37b58a98-2ebb-4757-8cca-9f433a8cb079
# ╠═2891e58d-8472-468d-b852-57296403416b
# ╟─a04c2da8-a89a-4838-b7b3-89b3d7248c9e
# ╟─6ef866b7-b18e-475b-ac77-bb7646790dc3
# ╟─d78afbbb-09fb-4a33-a4be-4c428d63ce89
# ╟─d74e95b7-368e-40c6-afc4-f0e8a3857cd9
# ╠═a38df79e-06ed-413a-8d36-efefe812ec83
# ╠═1dc9292e-5edc-4114-81f8-4efcb4bdb532
# ╠═7edd0655-71ef-43c7-a839-b9fdfaa4ec3b
# ╠═dcd80ebf-e023-476d-bde5-26c6357457af
# ╟─9c9e39b6-7cda-459e-8e15-3d580ffe5ee7
# ╟─2be5d46c-e053-4077-885c-29011cec2fc9
# ╠═19f650b2-89e6-43a2-8680-bf7f01cf2630
# ╟─d9369c5c-8159-4d43-8a88-491cf0116332
# ╟─92f4d247-fac6-41c4-b907-01839855c7f5
# ╟─f8536c10-03f8-4ef8-938a-6259143a1d57
# ╟─4bae8ee5-2ae8-43f4-afdf-9ebdcd8619b6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
