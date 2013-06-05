package jp.raohmaru.game.starorchestra.controller
{
import flash.data.EncryptedLocalStore;
import flash.net.SharedObject;
import flash.utils.ByteArray;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameObject;
import jp.raohmaru.game.starorchestra.enums.Awards;
import jp.raohmaru.game.starorchestra.events.UserEvent;
import jp.raohmaru.game.starorchestra.model.User;

public final class UserMan extends GameObject
{
	private var _xml :XML,
				_user :User;

	public function UserMan(core :GameCore)
	{
		super(core);
	}

	public function createUser(userName :String) :void
	{
		if(_user) return;

		var so :SharedObject = SharedObject.getLocal("starorchestra"),
			userData :XMLList;

		if(so.data[userName] != null)
		{
			_xml = XML( so.data[userName] );
			userData = _xml.user.(alias == userName);
		}
		else
		{
			_xml =	<users />;
		}

		if(userData == null || userData.length() == 0)
		{
			userData =	new XMLList(<user>
										<alias>{userName}</alias>
										<phis>0</phis>
										<current>0,0</current>
										<max>0,0</max>
										<awards></awards>
										<gameComplete>false</gameComplete>
									</user>);
			_xml.appendChild( userData );
		}

		// DEBUG
		userData = null;
		_xml =	<users>
					<user>
						<alias>{userName}</alias>
						<phis>0</phis>
						<current>0,0</current>
						<max>9,9</max>
						<awards>
							<selectLevel /><freeMode /><beamSize />
						</awards>
						<gameComplete>false</gameComplete>
					</user>
				</users>;
		userData =	new XMLList(_xml.user[0]);
		// DEBUG

		_user = new User(userData);
	}

	public function destroy() :void
	{
		if(_user)
		{
			flushData();
			_user.destroy();
			_user = null;
		}
	}

	public function getUser() :User
	{
		return _user;
	}

	public function update() :void
	{
		flushData();
		_core.event.userEvent(UserEvent.UPDATE);
	}

	public function flushData() :void
	{
		var so :SharedObject = SharedObject.getLocal("starorchestra");
			so.data[_user.alias] = _xml.toString();
			so.flush();
	}
}
}