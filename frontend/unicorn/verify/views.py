# Create your views here.
from django.http import HttpResponse
from django.template import Context, loader
from django.contrib.auth.decorators import login_required 
from django.contrib.auth.decorators import permission_required 
from models import PatchInfo
from social_auth.models import *
from django.db.models import Q
from datetime import date, timedelta, datetime
import csv

def index(request):
    t = loader.get_template("index.html")
    c = Context()
    return HttpResponse(t.render(c))

@login_required
def review(request):
    t = loader.get_template("review.html")
    social = UserSocialAuth.objects.filter(user = request.user)
    githubusername = social[0].user
    # Handle post requests first
    if 'approve' in request.POST:
        id = request.POST['id']
        patch = PatchInfo.objects.get(Q(reviewer_username = githubusername), Q(id = id))[0]
        patch.username = githubusername
        patch.touched_time = datetime.now()        
    # Fetch a patch that has not been examined and is either has no reviewer
    # the current user as the reviewer OR is more than 2 days since last
    # given to a reviewer
    newpatch = False
    patch = None
    reviewlink = None
    id = None
    #try:
    newpatch = True
    patch = PatchInfo.objects.filter(Q(examined=False), Q(reviewer_username = '') | Q(reviewer_username = githubusername) | Q(touched_time__lte=date.today() - timedelta(2)))[0]
    patch.username = githubusername
    patch.touched_time = datetime.now()
    reviewlink = patch.diff_url
    id = patch.id
    #except Exception, err:
    #    newpatch = False
    c = Context({'ghusername' : githubusername, 'patch': patch, 'newpatch': newpatch, 'reviewlink': reviewlink, 'id': id})
    return HttpResponse(t.render(c))

@permission_required('verify.export')
def export(request):
    patches = PatchInfo.objects.filter(good=True,examined=True,exported=False)
    response = HttpResponse(mimetype='text/csv')
    response['Content-Disposition'] = 'attachment; filename="approved_patches.csv"'
    writer = csv.writer(response)
    writer.writerow(['diff_url','target_username','message_txt','twitter_txt','good'])
    for patch in patches:
        writer.writerow([patch.diff_url,patch.target_username,patch.message_txt,patch.twitter_txt,patch.good])
    patches.update(exported=True)
    return response
