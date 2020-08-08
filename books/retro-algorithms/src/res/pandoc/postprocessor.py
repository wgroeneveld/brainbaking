

class PostProcessor:
	def __init__(self, filename):
		self.filename = filename

	def load(self):
		with open(self.filename, 'r') as file:
  			self.filedata = file.read()

	def save(self):
		with open(self.filename, 'w') as file:
		  file.write(self.filedata)

	def replace_citep_with_cite(self):
		self.filedata = self.filedata.replace('citep{', 'cite{')

	def make_thoughts_of_first_words_of_piece(self, piece):
		# chapter starts with \chapter{Voorwoord}\label{voorwoord}} and blank lines
		# take the first words that do not start with \command{something} and wrap them in \newthought{}
		lines = self.filedata.splitlines()
		linenr = 0
		linenrs = []
		for line in lines:
			if "\\" + piece + "{" in line:
				linenrs.append(linenr)
			linenr += 1
		for linenr_to_process in linenrs:
			linenr_of_first_words = linenr_to_process + 1

			while (len(lines[linenr_of_first_words]) < 2) or (lines[linenr_of_first_words].startswith("\\")) or ("\\label{" in lines[linenr_of_first_words]):
				linenr_of_first_words += 1

			words = lines[linenr_of_first_words].split()
			lines[linenr_of_first_words] = "\\newthought{" + " ".join(words[0:3]) + "} " + " ".join(words[3:])
		
		self.filedata = "\n".join(lines)

	def process(self):
		self.load()
		
		print('... replacing citep with cite')
		self.replace_citep_with_cite()

		print('... making thoughts of first words')
		self.make_thoughts_of_first_words_of_piece('chapter')
		self.make_thoughts_of_first_words_of_piece('section')

		self.save()
		print('done, written to ' + self.filename)

processor = PostProcessor('boek.tex')
processor.process()

