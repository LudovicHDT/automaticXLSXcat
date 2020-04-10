#!/usr/bin/env julia

using XLSX, DataFrames, CSV, ExcelFiles
function main()
	# the script must not be with the datas in the same directory
	cd("./allDiagnostics")
	files :: Array{String,1} = readdir()
	n :: Int = length(files)

	# storing excel sheets in an array
	acc :: Vector{DataFrame} = [DataFrame() for i in 1:n]
	print(typeof(acc))
	print("\n")

	for i = 1:n
		print(i)
		print("\n")
		f :: String = files[i]
		print(f)
		print("\n")
		xf :: XLSX.XLSXFile = XLSX.readxlsx(f)
		sh :: Vector{String} = XLSX.sheetnames(xf)
		sh1 :: String = sh[1]
		r :: ExcelFiles.ExcelFile = load(f, sh1; skipstartrows = 2)
		df1 :: DataFrame = DataFrame(r)
		df2 :: DataFrame = select(df1, Not(:6))
		df3 :: DataFrame = dropmissing(df2)
		print(typeof(df3))
		print("\n")
		acc[i] :: DataFrame = df3
	end
	print(typeof(acc))
	print("\n")

	# concatenation of data frames in a data frame
	li ::Int = lastindex(acc)
	catDiag :: DataFrame = DataFrame(Symbol("Commune") => String[], Symbol("Section") => String[],
					 Symbol("N°") => Any[], Symbol("Lieu dit") => String[],
					 Symbol("Surface") => Float64[])

	for i = 1:li
		dfi :: DataFrame = acc[i]
		catDiag = vcat(catDiag, dfi; cols = :union)
	end
	print(typeof(catDiag))
	print("\n")

	CSV.write("concatDiags.csv", catDiag)

end
main()
