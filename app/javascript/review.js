import { route } from './util';

$(() => {
  $(document).on('ajax:success', 'a.feedback-button[data-remote]', e => {
    if (!$(e.target).hasClass('on-post')) {
      $('.post-cell-' + e.target.dataset.postId).remove();
      e.target.closest('tr').remove();
    }
  });
});

route(/\/review\/[\w-]+\/?\d*$/i, async () => {
  const queuePath = (/(\/review\/[\w-]+)\/?\d*$/i).exec(location.pathname)[1];
  const hasItemID = location.pathname.match(/\/review\/[\w-]+\/?\d+$/i);

  const loadNextPost = async () => {
    const response = await fetch(queuePath + '/next', {
      credentials: 'include'
    });
    const html = await response.text();
    $('.review-item-container').html(html);
  };

  if (!hasItemID) {
    loadNextPost();
  }

  $(document).on('ajax:success', '.review-submit-link', () => {
    $('.review-item-container').text('Loading...');
    loadNextPost();
  });

  $(document).on('click', '.review-next-link', () => {
    $('.review-item-container').text('Loading...');
    loadNextPost();
  });
});

route('/review/untagged-domains', () => {
  $(document).on('ajax:success', '.review-add-domain-tag', (e, data) => {
    const $noTags = $('.no-tags');
    if ($noTags.length > 0) {
      $noTags.remove();
      $('.domain-tag-list p').html('Tagged with: ' + data);
    }
    else {
      $('.domain-tag-list p').append(data);
    }
    $(e.target).find('input[type=text]').val('');
  });
});
