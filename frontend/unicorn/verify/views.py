# Create your views here.
from django.http import HttpResponse
from django.template import Context, loader
from django.contrib.auth.decorators import login_required 
from models import PatchInfo
from social_auth.models import *
from django.db.models import Q
from datetime import date, timedelta, datetime

def index(request):
    t = loader.get_template("index.html")
    c = Context()
    return HttpResponse(t.render(c))

@login_required
def review(request):
    t = loader.get_template("review.html")
    social = UserSocialAuth.objects.filter(user = request.user)
    githubusername = social[0].user
    # Fetch a patch that has not been examined and is either has no reviewer
    # the current user as the reviewer OR is more than 2 days since last
    # given to a reviewer
    newpatch = False
    patch = None
    try:
        patch = PatchInfo.objects.get(Q(examined=False), Q(reviewer_username = '') | Q(reviewer_username = githubusername) | Q(touched_time__lte=date.today() - timedelta(2)))[0]
        patch.username = githubusername
        patch.touched_time = datetime.now()
    except Exception, err:
        newpatches = True
    c = Context({'ghusername' : githubusername, 'patch': patch, 'newpatch': newpatch})
    return HttpResponse(t.render(c))
