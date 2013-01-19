# Create your views here.
from django.http import HttpResponse
from django.template import Context, loader
from django.contrib.auth.decorators import login_required 

def index(request):
    t = loader.get_template("index.html")
    c = Context()
    return HttpResponse(t.render(c))

@login_required
def review(request):
    t = loader.get_template("review.html")
    c = Context()
    return HttpResponse(t.render(c))
