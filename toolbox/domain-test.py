import io

fake_file = io.StringIO()
#print('hello world', file=fake_file)


with open('submit_here/snuff.txt', 'r', encoding='utf-8') as file1:

    for line in file1:
        print(line.strip().rstrip())

    #close file
    file1.close
