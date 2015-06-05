import requests
import bs4
import shutil
import os

root = "http://www.plateshack.com/y2k/"

states = {"ACT" : "act.html","Jervis_Bay" : "jervis.html","New_South_Wales" : "nswy2k.html",
"Northern_Territory" : "northernterritory.html","Queensland" : "queensland.html",
"South_Australia" : "southaustralia.htm","Tasmania" : "tasmania.htm","Victoria" : "victoria.html",
"Western_Australia" : "westernaustralia.html"}


abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname + "/Plates")

for dir,file in states.iteritems():
    print "Scraping page:",file
    if not os.path.exists(dir):
        os.makedirs(dir)
    page = requests.get(root + dir + "/" + file)
    elements = bs4.BeautifulSoup(page.text).select("img")
    f = lambda x : root + dir + "/" + x
    img_urls = map(f,[img.attrs.get("src") for img in elements])
    n = len(img_urls)
    for i, url in enumerate(img_urls):
        print "Downloading image",str(i),"/",str(n),"            \r"
        img = requests.get(url,stream=True)
        with open(dir + "/" + str(i) + ".jpg","wb") as out_file:
            shutil.copyfileobj(img.raw,out_file)