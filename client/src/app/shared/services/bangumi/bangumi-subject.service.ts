import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {environment} from '../../../../environments/environment';
import {SubjectSmall} from '../../models/subject/subject-small';
import {SubjectLarge} from '../../models/subject/subject-large';
import {SubjectMedium} from '../../models/subject/subject-medium';
import {map} from 'rxjs/operators';
import {SubjectEpisodes} from '../../models/subject/subject-episodes';

@Injectable({
  providedIn: 'root'
})
export class BangumiSubjectService {

  constructor(private http: HttpClient) {
  }

  public getSubject(subject_id: string, responseGroup = 'small'):
    Observable<SubjectMedium> | Observable<SubjectLarge> | Observable<SubjectSmall> {

    return this.http.get(`${environment.BANGUMI_API_URL}/subject/${subject_id}?responseGroup=${responseGroup}`)
      .pipe(
        map(res => {
          switch (responseGroup) {
            case 'small ':
              return new SubjectSmall().deserialize(res);
            case 'medium':
              return new SubjectMedium().deserialize(res);
            case 'large':
              return new SubjectLarge().deserialize(res);
            default:
              return new SubjectSmall().deserialize(res);
          }
        })
      );
  }

  public getSubjectEpisode(subject_id: string): Observable<SubjectEpisodes> {

    return this.http.get(`${environment.BANGUMI_API_URL}/subject/${subject_id}/ep`)
      .pipe(
        map(res => {
          if (res['code'] && res['code'] !== 200) {
            return new SubjectEpisodes();
          } else {
            return new SubjectEpisodes().deserialize(res);
          }

        })
      );
  }


}
