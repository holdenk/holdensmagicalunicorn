from django.db import models

# Create your models here.
class PatchInfo(models.Model):
    diff_url=models.CharField(max_length=1000, help_text="The URL of the github diff")
    target_username=models.CharField(max_length=1000, help_text="The target github user to apply the pull request to (if approved)")
    message_txt=models.CharField(max_length=1000, help_text="The commit message text")
    reviewer_username=models.CharField(max_length=1000, help_text="The username of the reviewer", null=True, blank=True)
    good = models.BooleanField(max_length=1000, help_text="Is this patch good",
                               default=False)
    examined = models.BooleanField(max_length=1000, help_text="Has this patch been examined",
                                   default=False)
    exported = models.BooleanField(max_length=1000, help_text="Has this patch been examined",
                                   default=False)
    touched_time = models.DateTimeField(null=True, blank=True)

