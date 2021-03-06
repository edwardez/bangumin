import {Component, Input, OnInit} from '@angular/core';
import {SpoilerExisted} from '../../../../../shared/models/spoiler/spoiler-existed';
import {Observable, of} from 'rxjs';
import {CopyEvent, ShareableStringGeneratorService} from '../../../../../shared/services/utils/shareable-string-generator.service';
import {map, take} from 'rxjs/operators';
import {AuthenticationService} from '../../../../../shared/services/auth.service';
// tslint:disable-next-line:max-line-length
import {SpoilerDeletionConfirmationDialogComponent} from '../spoiler-deletion-confirmation-dialog/spoiler-deletion-confirmation-dialog.component';
import { MatDialog } from '@angular/material/dialog';

/**
 * Template is ahred with share-bottom-sheet.component since they're the same
 */
@Component({
  selector: 'app-share-spoiler-menu',
  templateUrl: '../share-bottom-sheet/share-bottom-sheet.component.html',
  styleUrls: ['../share-bottom-sheet/share-bottom-sheet.component.scss']
})
export class ShareSpoilerMenuComponent implements OnInit {

  @Input()
  spoilerLink: string;

  @Input()
  spoilerContent: SpoilerExisted;

  twitterShareLink: Observable<string>;
  weiboShareLink: Observable<string>;
  copyableText: Observable<string>;
  canDelete: Observable<boolean>;

  constructor(
    private authenticationService: AuthenticationService,
    private shareableStringGeneratorService: ShareableStringGeneratorService,
    private dialog: MatDialog,) {
  }


  ngOnInit() {
    const relatesSubjectsNames: string[] =
      (this.spoilerContent.relatedSubjectsBaseDetails || []).map(relatedSubjectBase => relatedSubjectBase.subjectName.preferred);
    this.twitterShareLink = this.shareableStringGeneratorService.generateTwitterShareLink(relatesSubjectsNames, this.spoilerLink,
      this.spoilerContent.spoilerText);
    this.weiboShareLink = this.shareableStringGeneratorService.generateWeiboShareLink(relatesSubjectsNames, this.spoilerLink,
      this.spoilerContent.spoilerText);
    this.copyableText = this.shareableStringGeneratorService.generateCopyableText(relatesSubjectsNames, this.spoilerLink,
      this.spoilerContent.spoilerText);
    this.canDelete = this.authenticationService.userSubject
      .pipe(
        map(userSubject => {
          if (userSubject) {
            return userSubject.id === Number(this.spoilerContent.userId);
          }
          return false;
        }),
        take(1)
      );
  }

  handleCopyCallback(event: CopyEvent, text: Observable<string> | string) {
    this.shareableStringGeneratorService.handleCopyCallback(event, text instanceof Observable ? text : of(text), this.spoilerLink)
      .subscribe();
  }


  deleteSpoiler() {
    const dialogRef = this.dialog.open(SpoilerDeletionConfirmationDialogComponent, {
      data: this.spoilerContent
    });
  }

  // placeholder method
  dismissSheet(): void {
  }


}
