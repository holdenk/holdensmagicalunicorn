# Create your views here.
from django.http import HttpResponse
from django.template import Context, loader
from django.contrib.auth.decorators import login_required 
from models import PatchInfo
from social_auth.models import *

def index(request):
    t = loader.get_template("index.html")
    c = Context()
    return HttpResponse(t.render(c))

@login_required
def review(request):
    t = loader.get_template("review.html")
    social = UserSocialAuth.objects.filter(user = request.user)
    githubusername = social[0].user
    c = Context({'ghusername' : githubusername})
    return HttpResponse(t.render(c))
