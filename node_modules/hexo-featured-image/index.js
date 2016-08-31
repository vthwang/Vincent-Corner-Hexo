var fs = require('hexo-fs');
var yaml = require('yaml-front-matter');

var contentJsonPath = hexo.public_dir + 'content.json';
var post_asset_folder = hexo.config.post_asset_folder;
var imagesPath = hexo.config.url + hexo.config.root;
if (!post_asset_folder) {
	if (hexo.config.image_dir) {
		imagesPath += hexo.config.image_dir;
	} else {
		imagesPath += 'images';
	}
	imagesPath += '/';
}

hexo.extend.filter.register('before_post_render', function(data) {
	var featured_image = yaml.loadFront(data.raw).featured_image;
	if (featured_image){
		var thumbnail = yaml.loadFront(data.raw).thumbnail;
		if (post_asset_folder) {
			data.featured_image = data.permalink + featured_image;
			if(thumbnail){
				data.thumbnail = data.permalink + thumbnail;
			}
		} else {
			data.featured_image = imagesPath + featured_image;
			if(thumbnail){
				data.thumbnail = imagesPath + thumbnail;
			}
		}
	}
	return data;
});

hexo.extend.filter.register('before_exit', function() {
	// to work smoothly with hexo_generator_json_content
	var jsonContentCfg = hexo.config.hasOwnProperty('jsonContent') ? hexo.config.jsonContent : {
		meta: true
	};
	var postsCfg = jsonContentCfg.hasOwnProperty('posts') ? jsonContentCfg.posts : {};

	if ((postsCfg.featured_image) && fs.existsSync(contentJsonPath)) {
		var postsObject = {};
		var posts = hexo.locals.get('posts');
		posts.forEach(function(post) {
			postsObject[post.path] = post;
		});
		var content = JSON.parse(fs.readFileSync(contentJsonPath));
		var contentPosts = content.posts;
		if (!contentPosts) return;
		content.posts = contentPosts.map(function(post) {
			var fullPost = postsObject[post.path];
			if (fullPost && fullPost.featured_image) {
				post.featured_image = fullPost.featured_image;
				if(postsCfg.thumbnail && fullPost.thumbnail){
					post.thumbnail = fullPost.thumbnail;
				}
			}
			return post;
		});
		fs.writeFileSync(contentJsonPath, JSON.stringify(content));
	}
});
